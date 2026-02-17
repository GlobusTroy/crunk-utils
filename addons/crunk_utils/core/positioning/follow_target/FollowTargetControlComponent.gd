class_name FollowTargetControlComponent
extends Control
## Component that makes a Control follow another Control's position.
##
## Provides smooth following behavior with pluggable motion interpolation and performance optimization.
## Supports following either the component itself or its parent node, with automatic performance
## management using transform notifications to minimize unnecessary processing.
##
## Example usage:
## [codeblock]
## var follower = FollowTargetControlComponent.new()
## follower.followed_control = target_button
## follower.motion_interpolator = LerpMotionInterpolator.new()
## follower.follower_type = FollowTargetControlComponent.FollowerType.PARENT
## add_child(follower)
## [/codeblock]

## Determines which node will be moved to follow the target.
enum FollowerType {
	SELF,
	PARENT,
}

enum FollowerPositionType {
	CENTERED,
	PIVOT,
	GLOBAL_POSITION	
}

## Determines how the target position is calculated.
enum TargetPositionType {
	## Uses the center of the target control (via injected proxy component)
	CENTERED_PROXY,
	## Uses the raw global position of the target control
	GLOBAL_TARGET_POSITION
}

const TRANSFORM_NOTIFIER_PREFAB : PackedScene = preload("res://addons/crunk_utils/core/positioning/follow_target/TransformNotifier.tscn")

@export_category("Targets")
## Which node should follow the target (self or parent)
@export var follower_type: FollowerType = FollowerType.PARENT
## How to calculate the follower position
@export var follower_position_type: FollowerPositionType = FollowerPositionType.CENTERED
## How to calculate the target position
@export var target_position_type: TargetPositionType = TargetPositionType.CENTERED_PROXY
## The control that this component should follow
@export var followed_control: Control : set = _set_followed_control

## Sets the target control to follow and updates the injected component.
## [param val]: The control to follow, or null to disable following
func _set_followed_control(val: Control) -> void:
	followed_control = val
	_initialize_injected_followed_component()

## Whether following is currently enabled
@export var is_follow_enabled: bool = true : set = _set_is_follow_enabled 

## Enables or disables following with proper performance management.
## [param val]: True to enable following, false to disable
func _set_is_follow_enabled(val: bool) -> void:
	is_follow_enabled = val
	if is_follow_enabled:
		if _is_at_destination():
			_set_notify_transform(true)
		else:
			set_process(true)
	else:
		set_process(false)
		_set_notify_transform(false)

@export_category("Motion")
## Strategy resource used to compute per-frame movement toward the target.
@export var motion_interpolator: ProcessMotionInterpolator = LerpMotionInterpolator.new()


## Cached reference to the parent control (only used when follower_type is PARENT)
var _parent: Control 
## Injected component used for CENTERED_PROXY positioning
var _injected_followed_component: TransformNotifier

## Updates the cached parent reference. Should be called when scene tree structure changes.
func update_cached_parent() -> void:
	_parent = get_parent() as Control

func _ready() -> void:
	if follower_type == FollowerType.PARENT:
		update_cached_parent()
	_initialize_injected_followed_component()

## Creates and configures the injected component for centered positioning.
## This component is added to the followed control to provide center positioning.
func _initialize_injected_followed_component() -> void:
	if not _injected_followed_component:
		_injected_followed_component = TRANSFORM_NOTIFIER_PREFAB.instantiate() as TransformNotifier
		if not _injected_followed_component:
			push_error("Failed to instantiate TransformNotifier prefab")
			return

	if not _injected_followed_component.transform_changed.is_connected(_on_injected_transform_changed):
		_injected_followed_component.transform_changed.connect(_on_injected_transform_changed)
		
	var prev_parent: Control = _injected_followed_component.get_parent_control()
	if prev_parent != followed_control:
		if prev_parent != null: prev_parent.remove_child(_injected_followed_component)
		if followed_control != null: 
			followed_control.add_child(_injected_followed_component)
			_injected_followed_component.set_anchors_and_offsets_preset(PRESET_CENTER, PRESET_MODE_MINSIZE)

## Gets the control that should be moved based on the follower_type setting.
## [return]: The control to move, or null if configuration is invalid
func _get_follower() -> Control:
	match follower_type:
		FollowerType.SELF: return self
		FollowerType.PARENT: return _parent
		_: return null


func _set_notify_transform(val: bool) -> void:
	set_notify_transform(val)
	if _injected_followed_component:
		_injected_followed_component.set_notify_transform(val)

## Handles transform change notifications for performance optimization.
## [param what]: The notification type
func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSFORM_CHANGED and not _is_at_destination():
		_set_notify_transform(false)
		set_process(true) 

## Handles transform changes from the injected target notifier.
## Reactivates process when target movement exceeds epsilon distance.
func _on_injected_transform_changed() -> void:
	if not is_follow_enabled or not followed_control:
		return

	if not _is_at_destination():
		_set_notify_transform(false)
		set_process(true)

## Checks if the follower is within the epsilon threshold of the target.
## [return]: True if close enough to target, false otherwise
func _is_at_destination() -> bool:
	var follower: Control = _get_follower()
	if not follower or not motion_interpolator:
		return true
	return motion_interpolator.is_at_destination(_get_follower_space_position(), _get_target_position())

## Calculates the target position based on target_position_type setting.
## [return]: The target position in global coordinates
func _get_target_position() -> Vector2:
	if not followed_control:
		return Vector2.ZERO
		
	match target_position_type:
		TargetPositionType.CENTERED_PROXY:
			if _injected_followed_component:
				return _injected_followed_component.global_position
			else:
				# Fallback to control position if injected component not available
				return followed_control.global_position
		TargetPositionType.GLOBAL_TARGET_POSITION:
			return followed_control.global_position
		_: 
			return followed_control.global_position

## Gets the offset from follower origin to its logical position
func _get_follower_offset() -> Vector2:
	var follower: Control = _get_follower()
	if not follower:
		return Vector2.ZERO
	match follower_position_type:
		FollowerPositionType.CENTERED: return follower.size / 2
		FollowerPositionType.PIVOT: return follower.get_combined_pivot_offset()
		FollowerPositionType.GLOBAL_POSITION: return Vector2.ZERO
		_: return Vector2.ZERO 

## Converts follower's global position to follower-space position
func _get_follower_space_position() -> Vector2:
	var follower: Control = _get_follower()
	if not follower:
		return Vector2.ZERO
	return follower.global_position + _get_follower_offset()

## Applies follower-space position to follower in global coordinates (accounting for offset)
func _apply_follower_position(global_pos: Vector2) -> void:
	var follower: Control = _get_follower()
	if not follower: return
	follower.global_position = global_pos - _get_follower_offset()

func _process(delta: float) -> void:
	if not is_follow_enabled or not followed_control: return
	
	var apply_to : Control = _get_follower()
	if not apply_to: return
	if not motion_interpolator: return
	
	var current_pos : Vector2 = _get_follower_space_position()
	var target_pos : Vector2 = _get_target_position()
	var next_pos : Vector2 = motion_interpolator.get_next_frame_position(current_pos, target_pos, delta)
	_apply_follower_position(next_pos)
	
	if motion_interpolator.is_at_destination(next_pos, target_pos):
		_snap_to_target()
	
## Instantly snaps the follower to the target position and optimizes performance.
func _snap_to_target() -> void:
	if not followed_control: return
	var apply_to : Control = _get_follower()
	if not apply_to: return
	
	var target_pos : Vector2 = _get_target_position()
	_apply_follower_position(target_pos)
	set_process(false)
	_set_notify_transform(true)
	

class_name FollowPointComponent
extends Node

@export var enabled: bool = true
@export var apply_to_node: Node = null
@export var target_node: Node = null
@export var target_global_position: Vector2 = Vector2.ZERO
@export var easing: float = 0.2
@export var use_speed_cap: bool = false
@export var max_speed: float = 1800.0
@export var deadzone: float = 0.5
@export var centered_for_control: bool = true

signal follow_started()
signal follow_stopped()

var _apply_node: Node = null
var _is_following: bool = false

func _ready() -> void:
	_apply_node = apply_to_node if apply_to_node else get_parent()
	set_process(false)

func set_target(pos: Vector2) -> void:
	set_target_global_position(pos)


func set_target_global_position(pos: Vector2) -> void:
	target_global_position = pos
	target_node = null
	if not enabled:
		return
	if not _is_following:
		_is_following = true
		follow_started.emit()
	set_process(true)


func set_target_node(node: Node) -> void:
	target_node = node
	if not enabled or target_node == null:
		return
	if not _is_following:
		_is_following = true
		follow_started.emit()
	set_process(true)

func snap_to_target() -> void:
	var resolved_target: Vector2 = _get_resolved_target_position()
	_apply_global_position(resolved_target)
	_stop_following()

func set_enabled(value: bool) -> void:
	enabled = value
	if not enabled:
		_stop_following()

func _process(delta: float) -> void:
	if not enabled or _apply_node == null:
		_stop_following()
		return
	if target_node != null and not is_instance_valid(target_node):
		target_node = null
	var resolved_target: Vector2 = _get_resolved_target_position()
	var current: Vector2 = _get_global_position()
	var next: Vector2 = current.lerp(resolved_target, easing)
	if use_speed_cap:
		var step: float = max_speed * delta
		next = current.move_toward(resolved_target, step)
	_apply_global_position(next)
	if next.distance_to(resolved_target) <= deadzone:
		_apply_global_position(resolved_target)
		_stop_following()

func _stop_following() -> void:
	if _is_following:
		_is_following = false
		follow_stopped.emit()
	set_process(false)

func _get_global_position() -> Vector2:
	if _apply_node is Control:
		var control: Control = _apply_node as Control
		if centered_for_control:
			return control.global_position + ((control.size * 0.5 - control.pivot_offset) * control.scale)
		return control.global_position
	if _apply_node is Node2D:
		return (_apply_node as Node2D).global_position
	return Vector2.ZERO

func _apply_global_position(pos: Vector2) -> void:
	if _apply_node is Control:
		var control: Control = _apply_node as Control
		if centered_for_control:
			control.global_position = pos - ((control.size * 0.5 - control.pivot_offset) * control.scale)
		else:
			control.global_position = pos
		return
	if _apply_node is Node2D:
		(_apply_node as Node2D).global_position = pos


func _get_resolved_target_position() -> Vector2:
	if target_node is Control:
		var control: Control = target_node as Control
		if centered_for_control:
			return control.global_position + ((control.size * 0.5 - control.pivot_offset) * control.scale)
		return control.global_position
	if target_node is Node2D:
		return (target_node as Node2D).global_position
	return target_global_position

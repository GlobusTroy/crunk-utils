class_name CorePlayground
extends Control
## Simple playground for testing FollowTargetControlComponent with editor-driven configuration.

@export var target_a: ColorRect
@export var target_b: ColorRect
@export var follower: FollowTargetControlComponent
@export var follower2: FollowTargetControlComponent
@export var motion_types: Array[ProcessMotionInterpolator]

var _motion_type_i : int = -1

func _ready() -> void:
	# Initialize follower to follow target A by default
	if follower and target_a:
		follower.followed_control = target_a
	if follower and target_b:
		follower.followed_control = target_b

func _on_toggle_target_button_pressed() -> void:
	# Switch between target A and target B
	if follower.followed_control == target_a:
		follower.followed_control = target_b
		follower2.followed_control = target_a
	else:
		follower.followed_control = target_a
		follower2.followed_control = target_b

func _on_randomize_button_pressed() -> void:
	# Randomize positions of both targets within reasonable bounds
	var screen_size = get_viewport().get_visible_rect().size
	var margin = 50
	
	if target_a:
		target_a.position = Vector2(
			randf_range(margin, screen_size.x - margin - target_a.size.x),
			randf_range(margin, screen_size.y - margin - target_a.size.y)
		)
	
	if target_b:
		target_b.position = Vector2(
			randf_range(margin, screen_size.x - margin - target_b.size.x),
			randf_range(margin, screen_size.y - margin - target_b.size.y)
		)


func _on_toggle_motion_type_button_pressed() -> void:
	_motion_type_i = (_motion_type_i + 1) % motion_types.size()
	var next_motion_type: ProcessMotionInterpolator = motion_types[_motion_type_i]
	follower.motion_interpolator = next_motion_type
	follower2.motion_interpolator = next_motion_type.duplicate(true)
	$ToggleMotionTypeButton.text = "Toggle Motion: #{0} - {1}".format([_motion_type_i, next_motion_type.resource_name])
	_on_toggle_target_button_pressed()

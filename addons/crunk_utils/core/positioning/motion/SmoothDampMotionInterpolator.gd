class_name SmoothDampMotionInterpolator
extends ProcessMotionInterpolator

## smooth_time: roughly the time (seconds) to reach the target.
## Higher value = slower, more "lazy" motion.
@export var smooth_time: float = 0.1
@export var velocity_epsilon: float = 0.5

var _velocity : Vector2 = Vector2.ZERO 

## Returns exponentially smoothed next position based on current process delta.
func get_next_frame_position(current_position: Vector2, destination_position: Vector2, delta: float) -> Vector2:
	var next_position : Vector2 = CrunkMathUtils.smooth_damp_v2(current_position, 
												destination_position, _velocity, smooth_time, delta)
	_velocity = (next_position - current_position) / delta
	return next_position

func is_at_destination(current_position: Vector2, destination_position: Vector2) -> bool:
	return current_position.distance_to(destination_position) < epsilon and _velocity.length() < velocity_epsilon

func _reset_state() -> void:
	_velocity = Vector2.ZERO

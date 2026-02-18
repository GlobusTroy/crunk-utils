class_name BlendedMotionInterpolator
extends ProcessMotionInterpolator
## Motion interpolator that evenly blends next frame position from a list of interpolators

@export var blended_interpolators : Dictionary[ProcessMotionInterpolator, float] = {}

## Returns destination directly.
func get_next_frame_position(current_position: Vector2, destination_position: Vector2, delta: float) -> Vector2:
	var next_position_sum: Vector2 = Vector2.ZERO
	var weight_sum : float = 0.0
	
	for interpolator in blended_interpolators.keys():
		var weight: float = blended_interpolators[interpolator]
		next_position_sum += weight * interpolator.get_next_frame_position(current_position, 
																		destination_position, delta)
		weight_sum += weight
	return next_position_sum / weight_sum

func _reset_state() -> void:
	for interpolator in blended_interpolators:
		interpolator._reset_state()

func is_at_destination(current_position: Vector2, destination_position: Vector2) -> bool:
	for interpolator in blended_interpolators:
		if not interpolator.is_at_destination(current_position, destination_position): return false
	return true

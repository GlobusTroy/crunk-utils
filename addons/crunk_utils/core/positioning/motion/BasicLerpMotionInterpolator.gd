class_name BasicLerpMotionInterpolator
extends ProcessMotionInterpolator
## Motion interpolator that lerps toward destination without decay

## Smoothing speed (higher moves faster).
@export var lerp_speed: float = 10.0

## Returns exponentially smoothed next position based on current process delta.
func get_next_frame_position(current_position: Vector2, destination_position: Vector2, delta: float) -> Vector2:
	var target_position: Vector2 = current_position.lerp(destination_position, lerp_speed)
	var difference_vector: Vector2 = target_position - current_position
	return current_position + (difference_vector * delta)
	

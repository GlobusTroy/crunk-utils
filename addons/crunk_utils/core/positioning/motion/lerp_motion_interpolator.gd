class_name LerpMotionInterpolator
extends ProcessMotionInterpolator
## Motion interpolator that lerps toward destination using exponential decay.

## Smoothing speed (higher moves faster).
@export var lerp_speed: float = 10.0

## Returns exponentially smoothed next position based on current process delta.
func get_next_frame_position(current_position: Vector2, destination_position: Vector2, delta: float) -> Vector2:
	var weight: float = CrunkMathUtils.get_exponential_decay_weight(lerp_speed, delta)
	return current_position.lerp(destination_position, weight)

class_name LerpMotionInterpolator
extends ProcessMotionInterpolator
## Motion interpolator that lerps toward destination using exponential decay.

## Smoothing speed (higher moves faster).
@export var lerp_speed: float = 10.0

## Returns exponentially smoothed next position based on current process delta.
func get_next_frame_position(destination_position: Vector2, canvas_item_to_move: CanvasItem, delta: float) -> Vector2:
	var weight: float = CrunkMathUtils.get_exponential_decay_weight(lerp_speed, delta)
	var current_position: Vector2 = canvas_item_to_move.get_global_transform().origin
	return current_position.lerp(destination_position, weight)

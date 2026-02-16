class_name SnapMotionInterpolator
extends ProcessMotionInterpolator
## Motion interpolator that snaps instantly to destination.

## Returns destination directly.
func get_next_frame_position(destination_position: Vector2, canvas_item_to_move: CanvasItem, delta: float) -> Vector2:
	return destination_position

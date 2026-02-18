class_name SnapMotionInterpolator
extends ProcessMotionInterpolator
## Motion interpolator that snaps instantly to destination.

## Returns destination directly.
func get_next_frame_position(current_position: Vector2, destination_position: Vector2, delta: float) -> Vector2:
	return destination_position

class_name ProcessMotionInterpolator
extends Resource
## Base resource for per-frame position interpolation during process updates.
##
## Implementations provide a strategy to compute the next global position for a
## CanvasItem moving toward a destination.

## Distance threshold used to consider motion complete.
@export var epsilon: float = 0.5

## Returns the next global position for the given canvas item.
##
## [param destination_position]: Target global position.
## [param canvas_item_to_move]: Canvas item being moved.
## [param delta]: Frame delta in seconds.
## [return]: The position to apply this frame.
func get_next_frame_position(destination_position: Vector2, canvas_item_to_move: CanvasItem, delta: float) -> Vector2:
	push_error("ProcessMotionInterpolator.get_next_frame_position() must be overridden")
	return canvas_item_to_move.get_global_transform().origin

## Returns true when the canvas item is within epsilon of destination.
func is_at_destination(destination_position: Vector2, canvas_item_to_move: CanvasItem) -> bool:
	return canvas_item_to_move.get_global_transform().origin.distance_to(destination_position) < epsilon

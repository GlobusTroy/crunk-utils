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
## [param current_position]: Current global position.
## [param destination_position]: Target global position.
## [param delta]: Frame delta in seconds.
## [return]: The position to apply this frame.
func get_next_frame_position(current_position: Vector2, destination_position: Vector2, delta: float) -> Vector2:
	push_error("ProcessMotionInterpolator.get_next_frame_position() must be overridden")
	return destination_position

## Returns true when the canvas item is within epsilon of destination.
func is_at_destination(current_position: Vector2, destination_position: Vector2) -> bool:
	return current_position.distance_to(destination_position) < epsilon

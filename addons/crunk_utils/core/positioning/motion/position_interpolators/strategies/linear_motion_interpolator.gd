class_name LinearMotionInterpolator
extends ProcessMotionInterpolator
## Motion interpolator that moves at a constant speed towards target.

## Speed in pixels per second.
@export var speed: float

## Returns next position moving at constant rate
func get_next_frame_position(current_position: Vector2, destination_position: Vector2, delta: float) -> Vector2:
	return current_position.move_toward(destination_position, delta * speed)

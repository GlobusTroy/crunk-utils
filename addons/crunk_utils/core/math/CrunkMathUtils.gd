class_name CrunkMathUtils
extends Object

static func get_exponential_decay_weight(lerp_speed: float, delta: float) -> float:
	return 1.0 - exp(-lerp_speed * delta)

## A snappier alternative to Exponential Decay.
## Moves towards a target with spring-like behavior that doesn't overshoot.
static func smooth_damp_v2(current: Vector2, target: Vector2, velocity: Vector2, smooth_time: float, delta: float) -> Vector2:
	# smooth_time: roughly the time (seconds) to reach the target.
	# Higher value = slower, more "lazy" motion.
	
	var omega: float = 2.0 / smooth_time
	var x: float = omega * delta
	var exp_weight: float = 1.0 / (1.0 + x + 0.48 * x * x + 0.235 * x * x * x)
	
	var change: Vector2 = current - target
	var temp: Vector2 = (velocity + omega * change) * delta
	
	velocity = (velocity - omega * temp) * exp_weight
	return target + (change + temp) * exp_weight

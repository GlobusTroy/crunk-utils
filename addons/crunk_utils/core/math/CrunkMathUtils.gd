class_name CrunkMathUtils
extends Object

static func get_exponential_decay_weight(lerp_speed: float, delta: float) -> float:
	return 1.0 - exp(-lerp_speed * delta)

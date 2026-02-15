class_name SmoothCenterContainer
extends Container

@export var follow_easing: float = 0.2
@export var settle_deadzone: float = 0.5
@export var affect_rotation: bool = false
@export var affect_scale: bool = false

signal child_settled(child: Control)

var _targets: Dictionary = {}

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	set_process(false)

func _notification(what: int) -> void:
	if what == NOTIFICATION_SORT_CHILDREN:
		_rebuild_targets()

func _process(_delta: float) -> void:
	var should_continue: bool = false
	for child_variant: Variant in _targets.keys():
		if not child_variant is Control:
			continue
		var child: Control = child_variant as Control
		if not is_instance_valid(child):
			continue
		var target_rect: Rect2 = _targets[child]
		var desired_center: Vector2 = target_rect.position + (target_rect.size * 0.5)
		var current_center: Vector2 = child.position + (child.size * 0.5)
		var next_center: Vector2 = current_center.lerp(desired_center, follow_easing)
		child.position += next_center - current_center
		if child.position.distance_to(target_rect.position) > settle_deadzone:
			should_continue = true
		else:
			child.position = target_rect.position
			child_settled.emit(child)
	if not should_continue:
		set_process(false)

func _rebuild_targets() -> void:
	_targets.clear()
	var target_size: Vector2 = size
	for child_node: Node in get_children():
		if not child_node is Control:
			continue
		var child: Control = child_node as Control
		if child.size == Vector2.ZERO:
			child.size = child.get_combined_minimum_size()
		var pos: Vector2 = (target_size - child.size) * 0.5
		var target_rect: Rect2 = Rect2(pos, child.size)
		_targets[child] = target_rect
		fit_child_in_rect(child, Rect2(child.position, child.size))
	if not _targets.is_empty():
		set_process(true)

func get_center_global_pos() -> Vector2:
	return global_position + (size * 0.5)

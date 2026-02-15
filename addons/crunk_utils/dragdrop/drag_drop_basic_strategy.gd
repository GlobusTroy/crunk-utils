class_name DragDropBasicStrategy
extends DragDropSystemStrategyBase

## Default drag-drop strategy with cursor following, snap-to-receptor, and return-to-origin.

@export var snap_duration: float = 0.2
@export var return_duration: float = 0.3

var _drag_origin: Vector2 = Vector2.ZERO
var _active_target: Control = null
var _active_tween: Tween = null


func _on_drag_started(_draggable: Node, target_node: Node) -> void:
	if not target_node is Control:
		return
	_kill_active_tween()
	_active_target = target_node as Control
	_drag_origin = _active_target.global_position


func _on_drag_updated(_draggable: Node, _target_node: Node, _mouse_pos: Vector2) -> void:
	pass


func _on_drop_completed(
	_draggable: Node, target_node: Node,
	receptor_node: Node,
	is_valid_drop: bool
) -> void:
	if not target_node is Control:
		return
	var target_control: Control = target_node as Control
	if is_valid_drop and receptor_node is Control:
		var receptor_control: Control = receptor_node as Control
		target_control.scale = Vector2.ONE
		var receptor_center: Vector2 = _get_control_center(receptor_control)
		var destination: Vector2 = _get_global_position_for_center(
			target_control,
			receptor_center
		)
		_tween_to_position(target_control, destination, snap_duration)
	else:
		_tween_to_position(target_control, _drag_origin, return_duration)


func _kill_active_tween() -> void:
	if _active_tween and _active_tween.is_valid():
		_active_tween.kill()
	_active_tween = null


func _tween_to_position(target: Control, destination: Vector2, duration: float) -> void:
	_kill_active_tween()
	_active_tween = create_tween()
	_active_tween.tween_property(target, "global_position", destination, duration) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	_active_tween.finished.connect(_on_tween_finished)


func _on_tween_finished() -> void:
	_active_target = null
	_active_tween = null


func _get_control_center(control: Control) -> Vector2:
	var local_center: Vector2 = control.size * 0.5
	return control.global_position + ((local_center - control.pivot_offset) * control.scale)


func _get_global_position_for_center(control: Control, center: Vector2) -> Vector2:
	var local_center: Vector2 = control.size * 0.5
	var center_offset: Vector2 = (local_center - control.pivot_offset) * control.scale
	return center - center_offset

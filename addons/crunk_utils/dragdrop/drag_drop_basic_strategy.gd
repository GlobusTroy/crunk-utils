class_name DragDropBasicStrategy
extends DragDropSystemStrategyBase

## Default drag-drop strategy with cursor following, snap-to-receptor, and return-to-origin.

@export var follow_easing: float = 0.15
@export var snap_duration: float = 0.2
@export var return_duration: float = 0.3

var _drag_origin: Vector2 = Vector2.ZERO
var _active_target: Control = null
var _active_tween: Tween = null
var _is_following: bool = false


func _process(_delta: float) -> void:
	if not _is_following or not is_instance_valid(_active_target):
		return
	var mouse_pos: Vector2 = _active_target.get_global_mouse_position()
	_active_target.global_position = _active_target.global_position.lerp(mouse_pos, follow_easing)


func _on_drag_started(
	draggable: DragDropDraggableComponent, target_node: Node
) -> void:
	if not target_node is Control:
		return
	_kill_active_tween()
	_active_target = target_node as Control
	_drag_origin = _active_target.global_position
	_is_following = true


func _on_drag_ended(
	_draggable: DragDropDraggableComponent, target_node: Node
) -> void:
	_is_following = false
	if not target_node is Control:
		return
	_tween_to_position(target_node as Control, _drag_origin, return_duration)


func _on_drop_completed(
	_draggable: DragDropDraggableComponent, target_node: Node,
	_receptor: DragDropReceptorComponent, receptor_node: Node,
	is_valid_drop: bool
) -> void:
	_is_following = false
	if not target_node is Control:
		return
	var target_control: Control = target_node as Control
	if is_valid_drop and receptor_node is Control:
		var receptor_control: Control = receptor_node as Control
		_tween_to_position(target_control, receptor_control.global_position, snap_duration)
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

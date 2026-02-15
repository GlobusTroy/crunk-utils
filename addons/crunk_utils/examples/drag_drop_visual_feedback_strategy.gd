class_name DragDropVisualFeedbackStrategy
extends DragDropSystemStrategyBase

const HOVER_SCALE: Vector2 = Vector2(1.1, 1.1)
const VALID_MODULATE: Color = Color(0.5, 1.0, 0.5)
const INVALID_MODULATE: Color = Color(1.0, 0.5, 0.5)


func _on_draggable_hover_start(
	_draggable: DragDropDraggableComponent, target_node: Node
) -> void:
	if target_node is Control:
		_tween_scale(target_node as Control, HOVER_SCALE)


func _on_draggable_hover_end(
	_draggable: DragDropDraggableComponent, target_node: Node
) -> void:
	if target_node is Control:
		_tween_scale(target_node as Control, Vector2.ONE)


func _on_drop_hover_start(
	_d: DragDropDraggableComponent, _tn: Node,
	_r: DragDropReceptorComponent, receptor_node: Node,
	is_valid_drop: bool
) -> void:
	if receptor_node is CanvasItem:
		var tint: Color = VALID_MODULATE if is_valid_drop else INVALID_MODULATE
		_tween_modulate(receptor_node as CanvasItem, tint)


func _on_drop_hover_end(
	_d: DragDropDraggableComponent, _tn: Node,
	_r: DragDropReceptorComponent, receptor_node: Node,
	_is_valid: bool
) -> void:
	if receptor_node is CanvasItem:
		_tween_modulate(receptor_node as CanvasItem, Color.WHITE)


func _on_drag_started(
	_draggable: DragDropDraggableComponent, target_node: Node
) -> void:
	if target_node is Control:
		(target_node as Control).z_index = 100


func _on_drag_ended(
	_draggable: DragDropDraggableComponent, target_node: Node
) -> void:
	if target_node is Control:
		(target_node as Control).z_index = 0


func _on_drop_completed(
	_d: DragDropDraggableComponent, target_node: Node,
	_r: DragDropReceptorComponent, _rn: Node, _valid: bool
) -> void:
	if target_node is Control:
		(target_node as Control).z_index = 0


func _tween_scale(control: Control, target: Vector2) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(control, "scale", target, 0.1)


func _tween_modulate(item: CanvasItem, target: Color) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(item, "modulate", target, 0.1)

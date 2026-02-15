class_name DragDropVisualFeedbackStrategy
extends DragDropSystemStrategyBase

const HOVER_SCALE: Vector2 = Vector2(1.1, 1.1)
const VALID_MODULATE: Color = Color(0.0, 2.0, 0.0, 1.0)
const INVALID_MODULATE: Color = Color(2.0, 0.0, 0.0, 1.0)
const DRAGGABLE_IDLE_Z_INDEX: int = 10
const DRAGGABLE_ACTIVE_Z_INDEX: int = 100

var _receptor_base_modulates: Dictionary = {}


func _on_draggable_hover_start(
	_draggable: DragDropDraggableComponent, target_node: Node
) -> void:
	if target_node is Control:
		var control: Control = target_node as Control
		_prepare_control_pivot(control)
		_tween_scale(control, HOVER_SCALE)


func _on_draggable_hover_end(
	_draggable: DragDropDraggableComponent, target_node: Node
) -> void:
	if target_node is Control:
		var control: Control = target_node as Control
		_prepare_control_pivot(control)
		_tween_scale(control, Vector2.ONE)


func _on_drop_hover_start(
	_d: DragDropDraggableComponent, _tn: Node,
	_r: DragDropReceptorComponent, receptor_node: Node,
	is_valid_drop: bool
) -> void:
	if receptor_node is CanvasItem:
		var receptor_item: CanvasItem = receptor_node as CanvasItem
		_store_receptor_base_modulate(receptor_item)
		var tint: Color = VALID_MODULATE if is_valid_drop else INVALID_MODULATE
		_tween_modulate(receptor_item, tint)


func _on_drop_hover_end(
	_d: DragDropDraggableComponent, _tn: Node,
	_r: DragDropReceptorComponent, receptor_node: Node,
	_is_valid: bool
) -> void:
	if receptor_node is CanvasItem:
		_reset_receptor_modulate(receptor_node as CanvasItem)


func _on_drag_started(
	_draggable: DragDropDraggableComponent, target_node: Node
) -> void:
	if target_node is Control:
		var control: Control = target_node as Control
		control.z_index = DRAGGABLE_ACTIVE_Z_INDEX


func _on_drag_ended(
	_draggable: DragDropDraggableComponent, target_node: Node
) -> void:
	if target_node is Control:
		var control: Control = target_node as Control
		control.z_index = DRAGGABLE_IDLE_Z_INDEX
	_reset_all_receptor_modulates()


func _on_drop_completed(
	_d: DragDropDraggableComponent, target_node: Node,
	_r: DragDropReceptorComponent, _rn: Node, _valid: bool
) -> void:
	if target_node is Control:
		var control: Control = target_node as Control
		control.z_index = DRAGGABLE_IDLE_Z_INDEX
	_reset_all_receptor_modulates()


func _tween_scale(control: Control, target: Vector2) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(control, "scale", target, 0.1)


func _tween_modulate(item: CanvasItem, target: Color) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(item, "modulate", target, 0.14)


func _prepare_control_pivot(control: Control) -> void:
	control.pivot_offset = control.size * 0.5


func _store_receptor_base_modulate(receptor_item: CanvasItem) -> void:
	var instance_id: int = receptor_item.get_instance_id()
	if _receptor_base_modulates.has(instance_id):
		return
	_receptor_base_modulates[instance_id] = receptor_item.modulate


func _reset_receptor_modulate(receptor_item: CanvasItem) -> void:
	var instance_id: int = receptor_item.get_instance_id()
	if not _receptor_base_modulates.has(instance_id):
		return
	var base_modulate: Color = _receptor_base_modulates[instance_id] as Color
	_tween_modulate(receptor_item, base_modulate)
	_receptor_base_modulates.erase(instance_id)


func _reset_all_receptor_modulates() -> void:
	for key: Variant in _receptor_base_modulates.keys():
		var instance_id: int = key as int
		var object: Object = instance_from_id(instance_id)
		if object is CanvasItem:
			var item: CanvasItem = object as CanvasItem
			var base_modulate: Color = _receptor_base_modulates[instance_id] as Color
			item.modulate = base_modulate
	_receptor_base_modulates.clear()

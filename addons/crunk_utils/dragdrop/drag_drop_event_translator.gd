class_name DragDropEventTranslator
extends RefCounted

signal drag_started(draggable_component: DragDropDraggableBaseComponent, dragged_node: Node)
signal drag_updated(draggable_component: DragDropDraggableBaseComponent, dragged_node: Node, mouse_pos: Vector2)
signal receptor_hover_changed(old_receptor: DragDropReceptorBaseComponent, new_receptor: DragDropReceptorBaseComponent)
signal drop_requested(draggable_component: DragDropDraggableBaseComponent, dragged_node: Node, receptor_component: DragDropReceptorBaseComponent)
signal drag_cancelled(draggable_component: DragDropDraggableBaseComponent, dragged_node: Node)

var active_draggable_component: DragDropDraggableBaseComponent = null
var active_dragged_node: Node = null
var hovered_receptor_component: DragDropReceptorBaseComponent = null
var drag_origin_parent: Node = null
var drag_origin_index: int = -1

var _bus: InputSignalBus = null
var _draggables_by_node: Dictionary = {}
var _receptors_by_node: Dictionary = {}

func bind_bus(bus: InputSignalBus) -> void:
	if _bus != null:
		_unbind_bus()
	_bus = bus
	if _bus == null:
		return
	_bus.mouse_down.connect(_on_mouse_down)
	_bus.mouse_up.connect(_on_mouse_up)
	_bus.mouse_entered.connect(_on_mouse_entered)
	_bus.mouse_exited.connect(_on_mouse_exited)

func dispose() -> void:
	_unbind_bus()
	_draggables_by_node.clear()
	_receptors_by_node.clear()
	active_draggable_component = null
	active_dragged_node = null
	hovered_receptor_component = null
	drag_origin_parent = null
	drag_origin_index = -1

func register_draggable(component: DragDropDraggableBaseComponent, source_node: Node) -> void:
	if source_node == null:
		return
	_draggables_by_node[source_node] = component

func unregister_draggable(source_node: Node) -> void:
	if source_node == null:
		return
	_draggables_by_node.erase(source_node)
	if active_dragged_node == source_node and active_draggable_component != null:
		drag_cancelled.emit(active_draggable_component, active_dragged_node)
		active_draggable_component = null
		active_dragged_node = null
		hovered_receptor_component = null

func register_receptor(component: DragDropReceptorBaseComponent, source_node: Node) -> void:
	if source_node == null:
		return
	_receptors_by_node[source_node] = component

func unregister_receptor(source_node: Node) -> void:
	if source_node == null:
		return
	var receptor: DragDropReceptorBaseComponent = _receptors_by_node.get(source_node, null)
	_receptors_by_node.erase(source_node)
	if receptor != null and receptor == hovered_receptor_component:
		receptor_hover_changed.emit(hovered_receptor_component, null)
		hovered_receptor_component = null

func _unbind_bus() -> void:
	if _bus == null:
		return
	if _bus.mouse_down.is_connected(_on_mouse_down):
		_bus.mouse_down.disconnect(_on_mouse_down)
	if _bus.mouse_up.is_connected(_on_mouse_up):
		_bus.mouse_up.disconnect(_on_mouse_up)
	if _bus.mouse_entered.is_connected(_on_mouse_entered):
		_bus.mouse_entered.disconnect(_on_mouse_entered)
	if _bus.mouse_exited.is_connected(_on_mouse_exited):
		_bus.mouse_exited.disconnect(_on_mouse_exited)
	_bus = null

func _on_mouse_down(source_node: Node, global_pos: Vector2, button_index: int) -> void:
	var draggable: DragDropDraggableBaseComponent = _draggables_by_node.get(source_node, null)
	if draggable == null:
		return
	var expected_button: int = int(draggable.input_button)
	if button_index != expected_button:
		return
	if not draggable.enabled:
		return
	active_draggable_component = draggable
	active_dragged_node = draggable.get_dragged_node()
	if active_dragged_node == null:
		active_draggable_component = null
		return
	drag_origin_parent = active_dragged_node.get_parent()
	drag_origin_index = active_dragged_node.get_index()
	drag_started.emit(draggable, active_dragged_node)
	drag_updated.emit(draggable, active_dragged_node, global_pos)

func _on_mouse_up(source_node: Node, _global_pos: Vector2, button_index: int) -> void:
	if active_draggable_component == null:
		return
	var expected_button: int = int(active_draggable_component.input_button)
	if button_index != expected_button:
		return
	if source_node != active_dragged_node and source_node != active_draggable_component.get_input_source_node():
		return
	drop_requested.emit(active_draggable_component, active_dragged_node, hovered_receptor_component)
	active_draggable_component = null
	active_dragged_node = null
	hovered_receptor_component = null
	drag_origin_parent = null
	drag_origin_index = -1

func _on_mouse_entered(source_node: Node) -> void:
	if active_draggable_component == null:
		return
	var receptor: DragDropReceptorBaseComponent = _receptors_by_node.get(source_node, null)
	if receptor == null:
		return
	if not receptor.enabled:
		return
	if receptor == hovered_receptor_component:
		return
	var old_receptor: DragDropReceptorBaseComponent = hovered_receptor_component
	hovered_receptor_component = receptor
	receptor_hover_changed.emit(old_receptor, hovered_receptor_component)

func _on_mouse_exited(source_node: Node) -> void:
	if hovered_receptor_component == null:
		return
	var receptor: DragDropReceptorBaseComponent = _receptors_by_node.get(source_node, null)
	if receptor == null or receptor != hovered_receptor_component:
		return
	receptor_hover_changed.emit(hovered_receptor_component, null)
	hovered_receptor_component = null

func push_drag_update(mouse_pos: Vector2) -> void:
	if active_draggable_component == null or active_dragged_node == null:
		return
	drag_updated.emit(active_draggable_component, active_dragged_node, mouse_pos)


func get_drag_origin_parent() -> Node:
	return drag_origin_parent


func get_drag_origin_index() -> int:
	return drag_origin_index

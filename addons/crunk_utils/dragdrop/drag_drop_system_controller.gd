class_name DragDropSystemController
extends Node

## Scene-tree orchestrator for drag/drop behavior.

const GROUP_NAME: String = "drag_drop_system_controllers"

signal drag_started(draggable_component: Node, dragged_node: Node)
signal drag_updated(draggable_component: Node, dragged_node: Node, mouse_pos: Vector2)
signal drop_completed(draggable_component: Node, dragged_node: Node, receptor_component: Node, is_valid_drop: bool)

@export var drag_overlay: Control = null

var _event_translator: DragDropEventTranslator = null
var _active_follow_component: FollowPointComponent = null
var _active_dragged_node: Node = null
var _origin_parent: Node = null
var _origin_index: int = -1
var _is_dragging: bool = false

func _ready() -> void:
	add_to_group(GROUP_NAME)
	_event_translator = DragDropEventTranslator.new()
	_event_translator.bind_bus(DragDropInputBus.get_instance().get_signal_bus())
	_event_translator.drag_started.connect(_on_drag_started)
	_event_translator.drag_updated.connect(_on_drag_updated)
	_event_translator.drop_requested.connect(_on_drop_requested)
	set_process(false)


func _exit_tree() -> void:
	if _event_translator:
		_event_translator.dispose()


func register_draggable_component(draggable: DragDropDraggableBaseComponent) -> void:
	if _event_translator == null or draggable == null:
		return
	_event_translator.register_draggable(draggable, draggable.get_input_source_node())


func unregister_draggable_component(draggable: DragDropDraggableBaseComponent) -> void:
	if _event_translator == null or draggable == null:
		return
	_event_translator.unregister_draggable(draggable.get_input_source_node())


func register_receptor_component(receptor: DragDropReceptorBaseComponent) -> void:
	if _event_translator == null or receptor == null:
		return
	_event_translator.register_receptor(receptor, receptor.get_input_source_node())


func unregister_receptor_component(receptor: DragDropReceptorBaseComponent) -> void:
	if _event_translator == null or receptor == null:
		return
	_event_translator.unregister_receptor(receptor.get_input_source_node())


func _on_drag_started(draggable_component: Node, dragged_node: Node) -> void:
	_is_dragging = true
	_active_dragged_node = dragged_node
	_origin_parent = _event_translator.get_drag_origin_parent()
	_origin_index = _event_translator.get_drag_origin_index()
	if drag_overlay and dragged_node.get_parent() != drag_overlay:
		dragged_node.reparent(drag_overlay, true)
	_active_follow_component = _ensure_follow_component(dragged_node)
	drag_started.emit(draggable_component, dragged_node)
	set_process(true)


func _on_drag_updated(draggable_component: Node, dragged_node: Node, mouse_pos: Vector2) -> void:
	if _active_follow_component:
		_active_follow_component.set_target_global_position(mouse_pos)
	drag_updated.emit(draggable_component, dragged_node, mouse_pos)


func _on_drop_requested(
	draggable_component: DragDropDraggableBaseComponent,
	dragged_node: Node,
	receptor_component: DragDropReceptorBaseComponent
) -> void:
	set_process(false)
	_is_dragging = false
	var is_valid_drop: bool = false
	if receptor_component and receptor_component.can_accept(draggable_component, dragged_node):
		is_valid_drop = true
		var drop_container: Node = receptor_component.get_drop_container()
		if drop_container:
			dragged_node.reparent(drop_container, true)
			if drop_container is Container:
				(drop_container as Container).queue_sort()
	else:
		_restore_to_origin(dragged_node)
	if _active_follow_component:
		_active_follow_component.set_enabled(false)
	drop_completed.emit(draggable_component, dragged_node, receptor_component, is_valid_drop)
	_active_follow_component = null
	_active_dragged_node = null


func _process(_delta: float) -> void:
	if not _is_dragging or _event_translator == null or _active_dragged_node == null:
		set_process(false)
		return
	if _active_dragged_node is CanvasItem:
		_event_translator.push_drag_update((_active_dragged_node as CanvasItem).get_global_mouse_position())


func _ensure_follow_component(target_node: Node) -> FollowPointComponent:
	for child: Node in target_node.get_children():
		if child is FollowPointComponent:
			var existing: FollowPointComponent = child as FollowPointComponent
			existing.set_enabled(true)
			return existing
	var follow_component: FollowPointComponent = FollowPointComponent.new()
	target_node.add_child(follow_component)
	follow_component.set_enabled(true)
	return follow_component


func _restore_to_origin(dragged_node: Node) -> void:
	if _origin_parent == null:
		return
	if not is_instance_valid(_origin_parent):
		return
	dragged_node.reparent(_origin_parent, true)
	if _origin_index >= 0 and _origin_index < _origin_parent.get_child_count():
		_origin_parent.move_child(dragged_node, _origin_index)
	if _origin_parent is Container:
		(_origin_parent as Container).queue_sort()

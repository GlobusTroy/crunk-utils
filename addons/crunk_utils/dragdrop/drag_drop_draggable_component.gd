class_name DragDropDraggableComponent
extends Node

## Base class for draggable components.
signal drag_started(component: DragDropDraggableComponent, target_node: Node)
signal drag_ended(component: DragDropDraggableComponent, target_node: Node)
signal draggable_hover_start(component: DragDropDraggableComponent, target_node: Node)
signal draggable_hover_end(component: DragDropDraggableComponent, target_node: Node)


func _ready() -> void:
	_register_with_system.call_deferred()


func _exit_tree() -> void:
	_unregister_from_system()


## Get the target node for this draggable component (default: parent)
func _get_target_node() -> Node:
	return get_parent() if get_parent() else self


## Register this draggable with all system controllers in the group
func _register_with_system() -> void:
	var controllers := get_tree().get_nodes_in_group(DragDropSystemController.GROUP_NAME)
	for controller: DragDropSystemController in controllers:
		if not is_instance_of(controller, DragDropSystemController):
			continue
		controller.register_draggable(self)


## Unregister this draggable from all system controllers in the group
func _unregister_from_system() -> void:
	var controllers := get_tree().get_nodes_in_group(DragDropSystemController.GROUP_NAME)
	for controller: DragDropSystemController in controllers:
		if not is_instance_of(controller, DragDropSystemController):
			continue
		controller.unregister_draggable(self)


## Emit drag started signal
func emit_drag_started() -> void:
	drag_started.emit(self, _get_target_node())


## Emit drag ended signal
func emit_drag_ended() -> void:
	drag_ended.emit(self, _get_target_node())


## Emit draggable hover start signal
func emit_draggable_hover_start() -> void:
	draggable_hover_start.emit(self, _get_target_node())


## Emit draggable hover end signal
func emit_draggable_hover_end() -> void:
	draggable_hover_end.emit(self, _get_target_node())

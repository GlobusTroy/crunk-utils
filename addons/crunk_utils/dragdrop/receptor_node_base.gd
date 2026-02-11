class_name DragDropReceptorComponent
extends Node

## Abstract base class for receptor components.
## Defines signals and interface for drop operations.

signal receptor_hover_start(receptor_component: DragDropReceptorComponent, target_node: Node)
signal receptor_hover_end(receptor_component: DragDropReceptorComponent, target_node: Node)


func _ready() -> void:
	_register_with_system.call_deferred()


func _exit_tree() -> void:
	_unregister_from_system()


## Check if this receptor can receive a specific draggable
func can_receive_drop(
	_draggable_component: DragDropDraggableComponent, 	
	_dragged_target_node: Node
) -> bool:
	return true


## Get the target node for this receptor component (default: parent)
func _get_target_node() -> Node:
	return get_parent() if get_parent() else self


## Register this receptor with all system controllers in the group
func _register_with_system() -> void:
	var controllers := get_tree().get_nodes_in_group(DragDropSystemController.GROUP_NAME)
	for controller: DragDropSystemController in controllers:
		if not is_instance_of(controller, DragDropSystemController):
			continue
		controller.register_receptor(self)


## Unregister this receptor from all system controllers in the group
func _unregister_from_system() -> void:
	var controllers := get_tree().get_nodes_in_group(DragDropSystemController.GROUP_NAME)
	for controller: DragDropSystemController in controllers:
		if not is_instance_of(controller, DragDropSystemController):
			continue
		controller.unregister_receptor(self)


## Emit receptor hover start signal
func emit_receptor_hover_start() -> void:
	receptor_hover_start.emit(self, _get_target_node())


## Emit receptor hover end signal
func emit_receptor_hover_end() -> void:
	receptor_hover_end.emit(self, _get_target_node())

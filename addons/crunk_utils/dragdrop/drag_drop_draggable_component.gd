class_name DragDropDraggableBaseComponent
extends Node

## Base draggable marker component.

@export var enabled: bool = true
@export var input_button: MouseButton = MOUSE_BUTTON_LEFT

var translator: InputSignalTranslator = null
var _input_source_node: Node = null


func _ready() -> void:
	_input_source_node = _resolve_input_source_node()
	if _input_source_node == null:
		push_error("DragDropDraggableBaseComponent: Could not resolve input source node")
		return
	translator = _create_translator()
	if translator == null:
		push_error("DragDropDraggableBaseComponent: _create_translator() returned null")
		return
	translator.bind(_input_source_node, DragDropInputBus.get_instance().get_signal_bus())
	_register_with_system.call_deferred()


func _exit_tree() -> void:
	if translator:
		translator.unbind()
	_unregister_from_system()


func get_dragged_node() -> Node:
	return get_parent() if get_parent() else self


func get_input_source_node() -> Node:
	return _input_source_node


func _resolve_input_source_node() -> Node:
	return get_parent() if get_parent() else self


func _create_translator() -> RefCounted:
	return null


## Register this draggable with all system controllers in the group
func _register_with_system() -> void:
	var controllers := get_tree().get_nodes_in_group(DragDropSystemController.GROUP_NAME)
	for controller: DragDropSystemController in controllers:
		if not is_instance_of(controller, DragDropSystemController):
			continue
		controller.register_draggable_component(self)


## Unregister this draggable from all system controllers in the group
func _unregister_from_system() -> void:
	var controllers := get_tree().get_nodes_in_group(DragDropSystemController.GROUP_NAME)
	for controller: DragDropSystemController in controllers:
		if not is_instance_of(controller, DragDropSystemController):
			continue
		controller.unregister_draggable_component(self)

class_name DragDropReceptorBaseComponent
extends Node

## Base receptor marker component.

@export var enabled: bool = true
@export var validator: DragDropValidatorBase = null

var translator: InputSignalTranslator = null
var _input_source_node: Node = null


func _ready() -> void:
	_input_source_node = _resolve_input_source_node()
	if _input_source_node == null:
		push_error("DragDropReceptorBaseComponent: Could not resolve input source node")
		return
	translator = _create_translator()
	if translator == null:
		push_error("DragDropReceptorBaseComponent: _create_translator() returned null")
		return
	translator.bind(_input_source_node, DragDropInputBus.get_instance().get_signal_bus())
	_register_with_system.call_deferred()


func _exit_tree() -> void:
	if translator:
		translator.unbind()
	_unregister_from_system()


func can_accept(draggable_component: Node, dragged_target_node: Node) -> bool:
	if validator == null:
		return true
	return validator.is_valid_drop(draggable_component, dragged_target_node)


func get_input_source_node() -> Node:
	return _input_source_node


func get_drop_container() -> Node:
	return get_parent() if get_parent() else self


func _resolve_input_source_node() -> Node:
	return get_parent() if get_parent() else self


func _create_translator() -> RefCounted:
	return null


## Register this receptor with all system controllers in the group
func _register_with_system() -> void:
	var controllers := get_tree().get_nodes_in_group(DragDropSystemController.GROUP_NAME)
	for controller: DragDropSystemController in controllers:
		if not is_instance_of(controller, DragDropSystemController):
			continue
		controller.register_receptor_component(self)


## Unregister this receptor from all system controllers in the group
func _unregister_from_system() -> void:
	var controllers := get_tree().get_nodes_in_group(DragDropSystemController.GROUP_NAME)
	for controller: DragDropSystemController in controllers:
		if not is_instance_of(controller, DragDropSystemController):
			continue
		controller.unregister_receptor_component(self)

class_name DragDropDraggableControlComponent
extends DragDropDraggableBaseComponent

## Control-specific draggable marker.

@export var target_control_path: NodePath

func _resolve_input_source_node() -> Node:
	if not target_control_path.is_empty():
		var target_node: Node = get_node_or_null(target_control_path)
		if target_node is Control:
			return target_node
	var parent_node: Node = get_parent()
	if parent_node is Control:
		return parent_node
	return null


func get_dragged_node() -> Node:
	return _resolve_input_source_node()


func _create_translator() -> RefCounted:
	return ControlInputSignalTranslator.new()

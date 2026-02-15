class_name DragDropReceptorControlComponent
extends DragDropReceptorBaseComponent

## Control-specific receptor marker with optional auto drop container.

@export var target_control_path: NodePath
@export var drop_container_path: NodePath
@export var auto_create_drop_container: bool = true
@export var auto_container_name: StringName = &"DropContainer"

var _auto_created_drop_container: Control = null


func _resolve_input_source_node() -> Node:
	if not target_control_path.is_empty():
		var from_path: Node = get_node_or_null(target_control_path)
		if from_path is Control:
			return from_path
	var parent_node: Node = get_parent()
	if parent_node is Control:
		return parent_node
	return null


func _create_translator() -> RefCounted:
	return ControlInputSignalTranslator.new()


func get_drop_container() -> Node:
	if not drop_container_path.is_empty():
		var from_path: Node = get_node_or_null(drop_container_path)
		if from_path is Control:
			return from_path
	if _auto_created_drop_container and is_instance_valid(_auto_created_drop_container):
		return _auto_created_drop_container
	if auto_create_drop_container:
		_auto_created_drop_container = _create_auto_drop_container()
		if _auto_created_drop_container:
			return _auto_created_drop_container
	return _resolve_input_source_node()


func _create_auto_drop_container() -> Control:
	var target_control: Control = _resolve_input_source_node() as Control
	if target_control == null:
		return null
	var existing_child: Node = target_control.get_node_or_null(NodePath(String(auto_container_name)))
	if existing_child is Control:
		return existing_child as Control
	var container: SmoothCenterContainer = SmoothCenterContainer.new()
	container.name = auto_container_name
	target_control.add_child(container)
	container.set_anchors_preset(Control.PRESET_FULL_RECT)
	container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	return container

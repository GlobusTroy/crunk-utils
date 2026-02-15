class_name DragDropSystemStrategyBase
extends Node

## Abstract base class for drag-drop strategies.

@export var controller: DragDropSystemController


func _ready() -> void:
	_discover_controller.call_deferred()


func _discover_controller() -> void:
	if controller:
		_connect_controller_signals()
		return
	var controllers := get_tree().get_nodes_in_group(DragDropSystemController.GROUP_NAME)
	for node: DragDropSystemController in controllers:
		controller = node
		break
	if not controller:
		push_error("DragDropSystemStrategyBase: No DragDropSystemController found in group.")
		return
	_connect_controller_signals()


func _connect_controller_signals() -> void:
	controller.drag_started.connect(_on_drag_started)
	controller.drag_updated.connect(_on_drag_updated)
	controller.drop_completed.connect(_on_drop_completed)


func _exit_tree() -> void:
	if controller:
		_disconnect_controller_signals()


func _disconnect_controller_signals() -> void:
	controller.drag_started.disconnect(_on_drag_started)
	controller.drag_updated.disconnect(_on_drag_updated)
	controller.drop_completed.disconnect(_on_drop_completed)


## Virtual handlers — override in subclasses

func _on_drag_started(
	_draggable: Node, _dragged_node: Node
) -> void:
	pass


func _on_drag_updated(
	_draggable: Node, _dragged_node: Node, _mouse_pos: Vector2
) -> void:
	pass


func _on_drop_completed(
	_draggable: Node, _dragged_node: Node,
	_receptor: Node,
	_is_valid_drop: bool
) -> void:
	pass

class_name DragDropSystemStrategyBase
extends Node

## Abstract base class for drag-drop system strategies.
## Connects to a DragDropSystemController and provides virtual handler methods
## for each signal. Subclass this to implement custom drag/drop behaviors.

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
	controller.drag_ended.connect(_on_drag_ended)
	controller.drop_completed.connect(_on_drop_completed)
	controller.drop_hover_start.connect(_on_drop_hover_start)
	controller.drop_hover_end.connect(_on_drop_hover_end)
	controller.draggable_hover_start.connect(_on_draggable_hover_start)
	controller.draggable_hover_end.connect(_on_draggable_hover_end)
	controller.receptor_hover_start.connect(_on_receptor_hover_start)
	controller.receptor_hover_end.connect(_on_receptor_hover_end)


func _exit_tree() -> void:
	if controller:
		_disconnect_controller_signals()


func _disconnect_controller_signals() -> void:
	controller.drag_started.disconnect(_on_drag_started)
	controller.drag_ended.disconnect(_on_drag_ended)
	controller.drop_completed.disconnect(_on_drop_completed)
	controller.drop_hover_start.disconnect(_on_drop_hover_start)
	controller.drop_hover_end.disconnect(_on_drop_hover_end)
	controller.draggable_hover_start.disconnect(_on_draggable_hover_start)
	controller.draggable_hover_end.disconnect(_on_draggable_hover_end)
	controller.receptor_hover_start.disconnect(_on_receptor_hover_start)
	controller.receptor_hover_end.disconnect(_on_receptor_hover_end)


## Virtual handlers — override in subclasses

func _on_drag_started(
	_draggable: DragDropDraggableComponent, _target_node: Node
) -> void:
	pass


func _on_drag_ended(
	_draggable: DragDropDraggableComponent, _target_node: Node
) -> void:
	pass


func _on_drop_completed(
	_draggable: DragDropDraggableComponent, _target_node: Node,
	_receptor: DragDropReceptorComponent, _receptor_node: Node,
	_is_valid_drop: bool
) -> void:
	pass


func _on_drop_hover_start(
	_draggable: DragDropDraggableComponent, _target_node: Node,
	_receptor: DragDropReceptorComponent, _receptor_node: Node,
	_is_valid_drop: bool
) -> void:
	pass


func _on_drop_hover_end(
	_draggable: DragDropDraggableComponent, _target_node: Node,
	_receptor: DragDropReceptorComponent, _receptor_node: Node,
	_is_valid_drop: bool
) -> void:
	pass


func _on_draggable_hover_start(
	_draggable: DragDropDraggableComponent, _target_node: Node
) -> void:
	pass


func _on_draggable_hover_end(
	_draggable: DragDropDraggableComponent, _target_node: Node
) -> void:
	pass


func _on_receptor_hover_start(
	_receptor: DragDropReceptorComponent, _target_node: Node
) -> void:
	pass


func _on_receptor_hover_end(
	_receptor: DragDropReceptorComponent, _target_node: Node
) -> void:
	pass

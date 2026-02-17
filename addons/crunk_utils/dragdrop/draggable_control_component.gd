# DraggableControlComponent.gd
class_name DraggableControlComponent
extends Node
## Component stub that registers its parent Control as a draggable with the DragDropEventBus.
##
## Attach as a child of any Control to make it participate in the drag-drop system.
## Drag behaviour is implemented in DragDropEventBus; this component handles
## discovery, registration, and input-bus wiring only.

var _parent_control: Control

func _enter_tree() -> void:
	_initialize.call_deferred()

func _initialize() -> void:
	_parent_control = get_parent() as Control
	if not _parent_control:
		push_error("DraggableControlComponent: parent must be a Control")
		return
	var bus: DragDropEventBus = _get_bus()
	if bus:
		bus.register_draggable(_parent_control, self)
		InputBusUtils.connect_control(_parent_control, bus.get_input_bus())

func _exit_tree() -> void:
	if not _parent_control:
		return
	var bus: DragDropEventBus = _get_bus()
	if bus:
		InputBusUtils.disconnect_control(_parent_control, bus.get_input_bus())
		bus.unregister_draggable(_parent_control)


func _get_bus() -> DragDropEventBus:
	return get_tree().get_first_node_in_group(DragDropEventBus.GROUP_NAME) as DragDropEventBus

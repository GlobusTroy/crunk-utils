# DragDropBehaviorBase.gd
class_name DragDropBehaviorBase
extends Node
## Base class for nodes that react to drag-drop system events.
##
## Discovers the DragDropEventBus via its group, connects all high-level
## signals to virtual handler methods, and disconnects cleanly on exit.
## Subclasses override whichever _on_* methods they care about.


func _ready() -> void:
	_initialize.call_deferred()
	
func _initialize() -> void:
	var bus: DragDropEventBus = _get_bus()
	if not bus:
		push_error("DragDropBehaviorBase: no DragDropEventBus found in group '%s'" % DragDropEventBus.GROUP_NAME)
		return
	bus.drag_started.connect(_on_drag_started)
	bus.drag_cancelled.connect(_on_drag_cancelled)
	bus.pending_drag_started.connect(_on_pending_drag_started)
	bus.pending_drag_stopped.connect(_on_pending_drag_stopped)
	bus.drop_requested.connect(_on_drop_requested)
	bus.receptor_hovered_changed.connect(_on_receptor_hovered_changed)
	bus.draggable_hovered_changed.connect(_on_draggable_hovered_changed)
	bus.draggable_registered.connect(_on_draggable_registered)
	for control: Control in bus.get_registered_draggables():
		_on_draggable_registered(bus.get_registered_draggables()[control], control)


func _exit_tree() -> void:
	var bus: DragDropEventBus = _get_bus()
	if not bus:
		return
	bus.drag_started.disconnect(_on_drag_started)
	bus.drag_cancelled.disconnect(_on_drag_cancelled)
	bus.pending_drag_started.disconnect(_on_pending_drag_started)
	bus.pending_drag_stopped.disconnect(_on_pending_drag_stopped)
	bus.drop_requested.disconnect(_on_drop_requested)
	bus.receptor_hovered_changed.disconnect(_on_receptor_hovered_changed)
	bus.draggable_hovered_changed.disconnect(_on_draggable_hovered_changed)
	bus.draggable_registered.disconnect(_on_draggable_registered)


func _get_bus() -> DragDropEventBus:
	return get_tree().get_first_node_in_group(DragDropEventBus.GROUP_NAME) as DragDropEventBus


func _on_drag_started(_draggable_component: DraggableControlComponent, _control: Control) -> void:
	pass


func _on_drag_cancelled(_draggable_component: DraggableControlComponent, _control: Control) -> void:
	pass


func _on_pending_drag_started(_draggable_component: DraggableControlComponent, _control: Control) -> void:
	pass


func _on_pending_drag_stopped(_draggable_component: DraggableControlComponent, _control: Control) -> void:
	pass


func _on_drop_requested(
		_draggable_component: DraggableControlComponent, _draggable_control: Control,
		_receptor_component: ReceptorControlComponent, _receptor_control: Control) -> void:
	pass


func _on_receptor_hovered_changed(
		_old_component: ReceptorControlComponent, _old_control: Control,
		_new_component: ReceptorControlComponent, _new_control: Control) -> void:
	pass


func _on_draggable_hovered_changed(
		_old_component: DraggableControlComponent, _old_control: Control,
		_new_component: DraggableControlComponent, _new_control: Control) -> void:
	pass


func _on_draggable_registered(_draggable_component: DraggableControlComponent, _control: Control) -> void:
	pass

# DragDropBehaviorBase.gd
class_name DragDropBehaviorBase
extends Node
## Base class for nodes that react to drag-drop system events.
##
## Discovers the DragDropEventBus via its group, connects all high-level
## signals to virtual handler methods, and disconnects cleanly on exit.
## Subclasses override whichever _on_* methods they care about.

var _event_bus: DragDropEventBus = null

func _ready() -> void:
	_event_bus = _get_bus()
	_initialize.call_deferred()
	
func _initialize() -> void:
	if not _event_bus:
		push_error("DragDropBehaviorBase: no DragDropEventBus found in group '%s'" % DragDropEventBus.GROUP_NAME)
		return
	_event_bus.drag_started.connect(_on_drag_started)
	_event_bus.drag_cancelled.connect(_on_drag_cancelled)
	_event_bus.pending_drag_started.connect(_on_pending_drag_started)
	_event_bus.pending_drag_stopped.connect(_on_pending_drag_stopped)
	_event_bus.drop_requested.connect(_on_drop_requested)
	_event_bus.receptor_hovered_changed.connect(_on_receptor_hovered_changed)
	_event_bus.draggable_hovered_changed.connect(_on_draggable_hovered_changed)
	_event_bus.draggable_registered.connect(_on_draggable_registered)
	for control: Control in _event_bus.get_registered_draggables():
		_on_draggable_registered(_event_bus.get_registered_draggables()[control], control)


func _exit_tree() -> void:
	if not _event_bus:
		return
	_event_bus.drag_started.disconnect(_on_drag_started)
	_event_bus.drag_cancelled.disconnect(_on_drag_cancelled)
	_event_bus.pending_drag_started.disconnect(_on_pending_drag_started)
	_event_bus.pending_drag_stopped.disconnect(_on_pending_drag_stopped)
	_event_bus.drop_requested.disconnect(_on_drop_requested)
	_event_bus.receptor_hovered_changed.disconnect(_on_receptor_hovered_changed)
	_event_bus.draggable_hovered_changed.disconnect(_on_draggable_hovered_changed)
	_event_bus.draggable_registered.disconnect(_on_draggable_registered)


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

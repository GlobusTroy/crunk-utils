# DragDropEventBus.gd
class_name DragDropEventBus
extends Node
## Event bus for a drag-drop system.
##
## Consumes raw GUI input events forwarded by subscribing components
## (DraggableControlComponent, ReceptorControlComponent) and emits high-level
## system events that a controller can react to.

const GROUP_NAME := &"drag_drop_event_bus"

## Emitted when a draggable control has been dragged past [member drag_threshold].
signal drag_started(draggable_component: DraggableControlComponent, control: Control)

## Emitted when an active drag is cancelled (right-click or released off a receptor).
signal drag_cancelled(draggable_component: DraggableControlComponent, control: Control)

## Emitted when a dragged control is released over a receptor.
signal drop_requested(
	draggable_component: DraggableControlComponent, draggable_control: Control,
	receptor_component: ReceptorControlComponent, receptor_control: Control)

## Emitted when the hovered receptor changes. Both old and new may be null.
signal receptor_hovered_changed(
	old_component: ReceptorControlComponent, old_control: Control,
	new_component: ReceptorControlComponent, new_control: Control)

## Emitted when the hovered draggable changes (suppressed while dragging). Both old and new may be null.
signal draggable_hovered_changed(
	old_component: DraggableControlComponent, old_control: Control,
	new_component: DraggableControlComponent, new_control: Control)

## Pixel distance the mouse must travel while held before a drag is initiated.
@export var drag_threshold: float = 5.0

var _input_bus: InputBusForNodes = InputBusForNodes.new()

# Registries populated by components at _ready / _exit_tree.
var _draggable_registry: Dictionary[Control, DraggableControlComponent] = {}
var _receptor_registry: Dictionary[Control, ReceptorControlComponent] = {}

# Pre-threshold drag state (mouse held but not yet past threshold).
var _pending_drag_component: DraggableControlComponent = null
var _pending_drag_control: Control = null
var _mouse_down_position: Vector2 = Vector2.ZERO

# Active drag state.
var _is_dragging: bool = false
var _dragged_component: DraggableControlComponent = null
var _dragged_control: Control = null

# Hover state.
var _hovered_draggable_component: DraggableControlComponent = null
var _hovered_draggable_control: Control = null
var _hovered_receptor_component: ReceptorControlComponent = null
var _hovered_receptor_control: Control = null


func get_input_bus() -> InputBusForNodes:
	return _input_bus


func _ready() -> void:
	add_to_group(GROUP_NAME)
	_input_bus.input_event.connect(_on_input_event)
	_input_bus.mouse_entered.connect(_on_mouse_entered)
	_input_bus.mouse_exited.connect(_on_mouse_exited)


# --- Registration API ---

func register_draggable(control: Control, component: DraggableControlComponent) -> void:
	_draggable_registry[control] = component


func unregister_draggable(control: Control) -> void:
	_draggable_registry.erase(control)


func register_receptor(control: Control, component: ReceptorControlComponent) -> void:
	_receptor_registry[control] = component


func unregister_receptor(control: Control) -> void:
	_receptor_registry.erase(control)


# --- Input handlers ---

func _on_mouse_entered(source: Control) -> void:
	if _draggable_registry.has(source):
		var component: DraggableControlComponent = _draggable_registry[source]
		var control: Control = source as Control
		if not _is_dragging:
			draggable_hovered_changed.emit(
				_hovered_draggable_component, _hovered_draggable_control,
				component, control)
			_hovered_draggable_component = component
			_hovered_draggable_control = control

	if _receptor_registry.has(source):
		var component: ReceptorControlComponent = _receptor_registry[source]
		var control: Control = source as Control
		receptor_hovered_changed.emit(
			_hovered_receptor_component, _hovered_receptor_control,
			component, control)
		_hovered_receptor_component = component
		_hovered_receptor_control = control


func _on_mouse_exited(source: Control) -> void:
	if source == _hovered_draggable_control:
		draggable_hovered_changed.emit(
			_hovered_draggable_component, _hovered_draggable_control,
			null, null)
		_hovered_draggable_component = null
		_hovered_draggable_control = null

	if source == _hovered_receptor_control:
		receptor_hovered_changed.emit(
			_hovered_receptor_component, _hovered_receptor_control,
			null, null)
		_hovered_receptor_component = null
		_hovered_receptor_control = null


func _on_input_event(event: InputEvent, source: Control) -> void:
	if event is InputEventMouseButton:
		_handle_mouse_button(event as InputEventMouseButton, source)
	elif event is InputEventMouseMotion:
		_handle_mouse_motion(event as InputEventMouseMotion)


func _handle_mouse_button(event: InputEventMouseButton, source: Control) -> void:
	if event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if _draggable_registry.has(source):
				_pending_drag_component = _draggable_registry[source]
				_pending_drag_control = source as Control
				_mouse_down_position = event.position
		else:
			if _is_dragging:
				if _hovered_receptor_component != null:
					drop_requested.emit(
						_dragged_component, _dragged_control,
						_hovered_receptor_component, _hovered_receptor_control)
				else:
					drag_cancelled.emit(_dragged_component, _dragged_control)
				_reset_drag_state()
			else:
				_clear_pending_drag()

	elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		if _is_dragging:
			drag_cancelled.emit(_dragged_component, _dragged_control)
			_reset_drag_state()


func _handle_mouse_motion(event: InputEventMouseMotion) -> void:
	if _pending_drag_component == null or _is_dragging:
		return
	if event.position.distance_to(_mouse_down_position) >= drag_threshold:
		_is_dragging = true
		_dragged_component = _pending_drag_component
		_dragged_control = _pending_drag_control
		_clear_pending_drag()
		drag_started.emit(_dragged_component, _dragged_control)


# --- State helpers ---

func _reset_drag_state() -> void:
	_is_dragging = false
	_dragged_component = null
	_dragged_control = null
	_clear_pending_drag()


func _clear_pending_drag() -> void:
	_pending_drag_component = null
	_pending_drag_control = null
	_mouse_down_position = Vector2.ZERO

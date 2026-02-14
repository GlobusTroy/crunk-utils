class_name DragDropDraggableControlComponent
extends DragDropDraggableComponent

## Control-based implementation of draggable component.
## Captures mouse events from the target Control to generate drag signals.

@export var target_control: Control
@export var drag_start_distance: float = 5.0

var _drag_start_position: Vector2

enum DragState {
	NOT_DRAGGING,
	BEGINNING_DRAG,
	DRAGGING
}

var _drag_state: DragState = DragState.NOT_DRAGGING

func _ready() -> void:
	super._ready()
	_setup_target_control()
	set_process_unhandled_input(false)


func _setup_target_control() -> void:
	if not target_control:
		target_control = get_parent() as Control
	
	if not target_control:
		push_error("DragDropDraggableControlComponent: Target control must be a Control node")
		return
	
	target_control.gui_input.connect(_on_gui_input)
	target_control.mouse_entered.connect(_on_mouse_entered)
	target_control.mouse_exited.connect(_on_mouse_exited)


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_drag_start_position = event.global_position
			_drag_state = DragState.BEGINNING_DRAG
			set_process_unhandled_input(true)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not event.pressed:
			_end_drag()
	elif event is InputEventMouseMotion and _drag_state == DragState.BEGINNING_DRAG:
		var distance: float = event.global_position.distance_to(_drag_start_position)
		if distance >= drag_start_distance:
			_start_drag()


func _on_mouse_entered() -> void:
	emit_draggable_hover_start()


func _on_mouse_exited() -> void:
	emit_draggable_hover_end()


func _start_drag() -> void:
	_drag_state = DragState.DRAGGING
	emit_drag_started()


func _end_drag() -> void:
	if _drag_state == DragState.DRAGGING:
		emit_drag_ended()
	_drag_state = DragState.NOT_DRAGGING
	set_process_unhandled_input(false)


## Get the target node for this draggable component
func _get_target_node() -> Control:
	return target_control
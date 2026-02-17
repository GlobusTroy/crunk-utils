extends Control
## Playground for testing DragMoverBehavior with draggable and receptor controls.
##
## This scene demonstrates the complete drag-drop workflow including:
## - Drag initiation after threshold movement
## - Smooth cursor following during drag
## - Visual feedback on receptor hover
## - Drop animation to receptor center
## - Cancel behavior (right-click or release outside)

@onready var _event_bus: DragDropEventBus = $DragDropEventBus
@onready var _drag_mover_behavior: DragMoverBehavior = $DragMoverBehavior
@onready var _status_label: Label = $StatusLabel


func _ready() -> void:
	# Connect to drag-drop events for visual feedback
	_event_bus.drag_started.connect(_on_drag_started)
	_event_bus.drag_cancelled.connect(_on_drag_cancelled)
	_event_bus.drop_requested.connect(_on_drop_requested)
	_event_bus.receptor_hovered_changed.connect(_on_receptor_hover_changed)
	_event_bus.draggable_hovered_changed.connect(_on_draggable_hover_changed)

	# Update status
	_update_status("Ready to drag! Right-click to cancel, drop on gray zones.")

func _on_drag_started(draggable_component: DraggableControlComponent, control: Control) -> void:
	_update_status("Dragging %s - Move to a gray drop zone or right-click to cancel" % control.name)
	# Visual feedback: make dragged control slightly transparent
	control.modulate.a = 0.7

func _on_drag_cancelled(draggable_component: DraggableControlComponent, control: Control) -> void:
	_update_status("Drag cancelled - %s returned to original position" % control.name)
	# Restore full opacity
	control.modulate.a = 1.0

func _on_drop_requested(
	draggable_component: DraggableControlComponent, draggable_control: Control,
	receptor_component: ReceptorControlComponent, receptor_control: Control) -> void:
	_update_status("Dropped %s on %s!" % [draggable_control.name, receptor_control.name])
	# Restore full opacity
	draggable_control.modulate.a = 1.0

func _on_receptor_hover_changed(
	old_component: ReceptorControlComponent, old_control: Control,
	new_component: ReceptorControlComponent, new_control: Control) -> void:
	# Visual feedback for receptors
	if old_control:
		old_control.modulate = Color.WHITE
	if new_control:
		new_control.modulate = Color(0.8, 0.8, 1.0)  # Light blue tint

func _on_draggable_hover_changed(
	old_component: DraggableControlComponent, old_control: Control,
	new_component: DraggableControlComponent, new_control: Control) -> void:
	# Visual feedback for draggables (when not actively dragging)
	if old_control and old_control.modulate.a == 1.0:
		old_control.scale = Vector2.ONE
	if new_control and new_control.modulate.a == 1.0:
		new_control.scale = Vector2(1.1, 1.1)  # Slightly scale up on hover

func _update_status(message: String) -> void:
	if _status_label:
		_status_label.text = message

class_name DragDropReceptorControlComponent
extends DragDropReceptorComponent

## Control-based implementation of receptor component.
## Captures mouse events from the target Control to generate receptor signals.

@export var target_control: Control

var _is_hovered: bool = false


func _ready() -> void:
	super._ready()
	_setup_target_control()


func _setup_target_control() -> void:
	if not target_control:
		target_control = get_parent() as Control
	
	if not target_control:
		push_error("DragDropReceptorControlComponent: Target control must be a Control node")
		return
	
	target_control.mouse_entered.connect(_on_mouse_entered)
	target_control.mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	if not _is_hovered:
		_is_hovered = true
		emit_receptor_hover_start()


func _on_mouse_exited() -> void:
	if _is_hovered:
		_is_hovered = false
		emit_receptor_hover_end()


## Get the target node for this receptor component
func _get_target_node() -> Control:
	return target_control

## Check if currently being hovered
func get_is_hovered() -> bool:
	return _is_hovered

## Override can_receive_drop with Control-specific validation
func can_receive_drop(
	_draggable_component: DragDropDraggableComponent, 
	_dragged_target_node: Node
) -> bool:
	return true
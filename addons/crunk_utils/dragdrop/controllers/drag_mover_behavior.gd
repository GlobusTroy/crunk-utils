# DragMoverBehavior.gd
class_name DragMoverBehavior
extends DragDropBehaviorBase
## Concrete behavior that moves draggable controls by redirecting their
## FollowTargetControlComponent to a mouse-tracking anchor during drag.
##
## On drag start, the draggable's FollowTargetControlComponent is pointed at a
## MouseTracker child of this node, causing it to smoothly follow the cursor.
## On cancel, the original target is restored. On drop, the target is set to
## the receptor control so the draggable animates to its new home.

## Scene template for auto-instantiating FollowTargetComponent on draggables that don't have one.
@export var follow_target_component_scene: PackedScene

@onready var _mouse_tracker: Control = $MouseTracker

## Maps each registered draggable component to its FollowTargetControlComponent child.
var _draggable_followers: Dictionary[DraggableControlComponent, FollowTargetControlComponent] = {}

## Active-drag state.
var _active_follow_component: FollowTargetControlComponent = null
var _original_follow_target: Control = null
var _is_active_drag: bool = false


func _process(_delta: float) -> void:
	if _is_active_drag:
		_mouse_tracker.global_position = _mouse_tracker.get_global_mouse_position()


func _on_draggable_registered(component: DraggableControlComponent, control: Control) -> void:
	for child: Node in control.get_children():
		if child is FollowTargetControlComponent:
			_draggable_followers[component] = child as FollowTargetControlComponent
			return
	
	# If no existing component and we have a scene template, auto-instantiate
	if follow_target_component_scene:
		var follow_component: FollowTargetControlComponent = follow_target_component_scene.instantiate() as FollowTargetControlComponent
		if follow_component:
			control.add_child(follow_component)
			_draggable_followers[component] = follow_component
			return
	
	# If we get here, either no scene assigned or instantiation failed
	push_warning(
		"DragMoverBehavior: '%s' has no FollowTargetControlComponent child and no scene template assigned — it will not be moved during drag"
		% control.name)


func _on_drag_started(component: DraggableControlComponent, _control: Control) -> void:
	if not _draggable_followers.has(component):
		return
	_active_follow_component = _draggable_followers[component]
	_original_follow_target = _active_follow_component.followed_control
	_active_follow_component.followed_control = _mouse_tracker
	_is_active_drag = true


func _on_drag_cancelled(_component: DraggableControlComponent, _control: Control) -> void:
	if not _active_follow_component:
		return
	_active_follow_component.followed_control = _original_follow_target
	_clear_drag_state()


func _on_drop_requested(
		_draggable_component: DraggableControlComponent, _draggable_control: Control,
		_receptor_component: ReceptorControlComponent, receptor_control: Control) -> void:
	if not _active_follow_component:
		return
	_active_follow_component.followed_control = receptor_control
	_clear_drag_state()


func _clear_drag_state() -> void:
	_is_active_drag = false
	_active_follow_component = null
	_original_follow_target = null

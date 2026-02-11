class_name DragDropSystemController
extends Node

## Central controller for managing drag and drop operations.
## Handles global drag state and coordinates between draggable and receptor nodes.

const GROUP_NAME: String = "drag_drop_system_controllers"

signal drag_started(draggable_component: DragDropDraggableComponent, target_node: Node)
signal drag_ended(draggable_component: DragDropDraggableComponent, target_node: Node)
signal drop_completed(
	draggable_component: DragDropDraggableComponent, target_node: Node, 
	receptor_component: DragDropReceptorComponent, receptor_node: Node,
	is_valid_drop: bool
)
signal drop_hover_start(
	draggable_component: DragDropDraggableComponent, target_node: Node, 
	receptor_component: DragDropReceptorComponent, receptor_node: Node, is_valid_drop: bool
)
signal drop_hover_end(
	draggable_component: DragDropDraggableComponent, target_node: Node, 
	receptor_component: DragDropReceptorComponent, receptor_node: Node, is_valid_drop: bool
)
signal draggable_hover_start(draggable_component: DragDropDraggableComponent, target_node: Node)
signal draggable_hover_end(draggable_component: DragDropDraggableComponent, target_node: Node)
signal receptor_hover_start(receptor_component: DragDropReceptorComponent, target_node: Node)
signal receptor_hover_end(receptor_component: DragDropReceptorComponent, target_node: Node)

var current_draggable: DragDropDraggableComponent = null
var current_draggable_target: Node = null
var current_receptor: DragDropReceptorComponent = null
var current_receptor_target: Node = null
var is_dragging: bool = false

var current_hovered_draggable: DragDropDraggableComponent = null
var current_hovered_draggable_target: Node = null

func _ready() -> void:
	add_to_group(GROUP_NAME)

func register_draggable(draggable: DragDropDraggableComponent) -> void:
	_connect_draggable_signals(draggable)


func register_receptor(receptor: DragDropReceptorComponent) -> void:
	_connect_receptor_signals(receptor)


func unregister_draggable(draggable: DragDropDraggableComponent) -> void:
	_disconnect_draggable_signals(draggable)


func unregister_receptor(receptor: DragDropReceptorComponent) -> void:
	_disconnect_receptor_signals(receptor)

func get_is_dragging() -> bool:
	return is_dragging

func start_drag(draggable: DragDropDraggableComponent, target_node: Node) -> void:
	current_draggable = draggable
	current_draggable_target = target_node
	is_dragging = true
	drag_started.emit(draggable, target_node)


func end_drag() -> void:
	if not is_dragging or current_draggable == null:
		return
	
	is_dragging = false
	if not is_instance_valid(current_receptor):
		drag_ended.emit(current_draggable, current_draggable_target)
	else:
		var is_valid_drop: bool = current_receptor.can_receive_drop(
			current_draggable, current_draggable_target
		)
		drop_completed.emit(
			current_draggable, current_draggable_target, 
			current_receptor, current_receptor_target, 
			is_valid_drop
		)
	current_draggable = null
	current_draggable_target = null

	var is_component_valid: bool = is_instance_valid(current_hovered_draggable) 
	var is_target_valid: bool = is_instance_valid(current_hovered_draggable_target)
	if is_component_valid and is_target_valid:
		draggable_hover_start.emit(current_hovered_draggable_target)

	is_component_valid = is_instance_valid(current_receptor)
	is_target_valid = is_instance_valid(current_receptor_target)
	if is_component_valid and is_target_valid:
		receptor_hover_start.emit(current_receptor, current_receptor_target)
	
func clear_current_receptor() -> void:
	if current_receptor:
		current_receptor = null
		current_receptor_target = null

func _connect_draggable_signals(draggable: DragDropDraggableComponent) -> void:
	draggable.drag_started.connect(_on_draggable_drag_started)
	draggable.drag_ended.connect(_on_draggable_drag_ended)
	draggable.draggable_hover_start.connect(_on_draggable_hover_start)
	draggable.draggable_hover_end.connect(_on_draggable_hover_end)


func _connect_receptor_signals(receptor: DragDropReceptorComponent) -> void:
	receptor.receptor_hover_start.connect(_on_receptor_hover_start)
	receptor.receptor_hover_end.connect(_on_receptor_hover_end)


func _disconnect_draggable_signals(draggable: DragDropDraggableComponent) -> void:
	draggable.drag_started.disconnect(_on_draggable_drag_started)
	draggable.drag_ended.disconnect(_on_draggable_drag_ended)
	draggable.draggable_hover_start.disconnect(_on_draggable_hover_start)
	draggable.draggable_hover_end.disconnect(_on_draggable_hover_end)


func _disconnect_receptor_signals(receptor: DragDropReceptorComponent) -> void:
	receptor.receptor_hover_start.disconnect(_on_receptor_hover_start)
	receptor.receptor_hover_end.disconnect(_on_receptor_hover_end)


func _on_draggable_drag_started(draggable: DragDropDraggableComponent, target_node: Node) -> void:
	if is_dragging:
		return
	start_drag(draggable, target_node)


func _on_draggable_drag_ended(draggable: DragDropDraggableComponent, _target_node: Node) -> void:
	if not is_dragging or draggable != current_draggable:
		return
	end_drag()

func _on_receptor_hover_start(receptor: DragDropReceptorComponent, receptor_target: Node) -> void:
	if current_receptor == receptor:
		return
	if is_instance_valid(current_receptor):
		if is_dragging:
			_emit_drop_hover_end()
		else:
			receptor_hover_end.emit(current_receptor, current_receptor_target)

	current_receptor = receptor
	current_receptor_target = receptor_target
	if is_dragging and is_instance_valid(current_draggable):
		_emit_drop_hover_start()
	else:
		receptor_hover_start.emit(receptor, receptor_target)


func _on_receptor_hover_end(receptor: DragDropReceptorComponent, receptor_target: Node) -> void:
	if current_receptor != receptor:
		return
	clear_current_receptor()
	if is_dragging:
		_emit_drop_hover_end()
	else:
		receptor_hover_end.emit(receptor, receptor_target)


## Emit drop hover start signal when draggable enters a receptor
func _emit_drop_hover_start() -> void:
	var is_valid_drop : bool = current_receptor.can_receive_drop(
			current_draggable, 
			current_draggable_target
		)
	drop_hover_start.emit(
		current_draggable, current_draggable_target, 
		current_receptor, current_receptor_target, is_valid_drop
	)


## Emit drop hover end signal when draggable exits a receptor
func _emit_drop_hover_end() -> void:
	var is_valid_drop: bool = current_receptor.can_receive_drop(
		current_draggable, 
		current_draggable_target
	)
	
	drop_hover_end.emit(
		current_draggable, current_draggable_target, 
		current_receptor, current_receptor_target, is_valid_drop
	)


## Handle draggable hover start - only emit if not dragging
func _on_draggable_hover_start(draggable: DragDropDraggableComponent, target_node: Node) -> void:
	if draggable == current_hovered_draggable:
		return
	if is_instance_valid(current_hovered_draggable) and not is_dragging:
		draggable_hover_end.emit(current_hovered_draggable, current_hovered_draggable_target)
	current_hovered_draggable = draggable
	current_hovered_draggable_target = target_node
	if not is_dragging:
		draggable_hover_start.emit(draggable, target_node)


## Handle draggable hover end - only emit if not dragging
func _on_draggable_hover_end(draggable: DragDropDraggableComponent, target_node: Node) -> void:
	if is_dragging:
		return
	draggable_hover_end.emit(draggable, target_node)

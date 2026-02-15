class_name InputSignalTranslator
extends RefCounted

## Base translator that binds a source node to an InputSignalBus.

var source_node: Node = null
var bus: InputSignalBus = null
var is_connected: bool = false

func bind(source: Node, target_bus: InputSignalBus) -> void:
	unbind()
	source_node = source
	bus = target_bus
	if source_node == null or bus == null:
		return
	_connect_signals()
	if source_node.tree_exiting.is_connected(_on_source_tree_exiting):
		return
	source_node.tree_exiting.connect(_on_source_tree_exiting)
	is_connected = true

func unbind() -> void:
	if source_node and source_node.tree_exiting.is_connected(_on_source_tree_exiting):
		source_node.tree_exiting.disconnect(_on_source_tree_exiting)
	if is_connected:
		_disconnect_signals()
	source_node = null
	bus = null
	is_connected = false

func _connect_signals() -> void:
	pass

func _disconnect_signals() -> void:
	pass

func _on_source_tree_exiting() -> void:
	unbind()

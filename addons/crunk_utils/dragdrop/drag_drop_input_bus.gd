class_name DragDropInputBus
extends Object

var _bus: InputSignalBus = InputSignalBus.new()

static var _instance: DragDropInputBus = null

static func get_instance() -> DragDropInputBus:
	if _instance == null:
		_instance = DragDropInputBus.new()
	return _instance

func get_signal_bus() -> InputSignalBus:
	return _bus

func reset() -> void:
	_bus = InputSignalBus.new()

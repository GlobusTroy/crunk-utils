class_name ControlInputSignalTranslator
extends InputSignalTranslator

## Control-specific translator for raw mouse primitives.

var _control: Control = null

func _connect_signals() -> void:
	if not source_node is Control:
		return
	_control = source_node as Control
	if not _control.gui_input.is_connected(_on_gui_input):
		_control.gui_input.connect(_on_gui_input)
	if not _control.mouse_entered.is_connected(_on_mouse_entered):
		_control.mouse_entered.connect(_on_mouse_entered)
	if not _control.mouse_exited.is_connected(_on_mouse_exited):
		_control.mouse_exited.connect(_on_mouse_exited)

func _disconnect_signals() -> void:
	if _control == null:
		return
	if _control.gui_input.is_connected(_on_gui_input):
		_control.gui_input.disconnect(_on_gui_input)
	if _control.mouse_entered.is_connected(_on_mouse_entered):
		_control.mouse_entered.disconnect(_on_mouse_entered)
	if _control.mouse_exited.is_connected(_on_mouse_exited):
		_control.mouse_exited.disconnect(_on_mouse_exited)
	_control = null

func _on_gui_input(event: InputEvent) -> void:
	if bus == null or _control == null:
		return
	if not event is InputEventMouseButton:
		return
	var mouse_event: InputEventMouseButton = event as InputEventMouseButton
	if mouse_event.pressed:
		bus.mouse_down.emit(_control, mouse_event.global_position, mouse_event.button_index)
	else:
		bus.mouse_up.emit(_control, mouse_event.global_position, mouse_event.button_index)

func _on_mouse_entered() -> void:
	if bus and _control:
		bus.mouse_entered.emit(_control)

func _on_mouse_exited() -> void:
	if bus and _control:
		bus.mouse_exited.emit(_control)

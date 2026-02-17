# InputBusUtils.gd
## Static utility class for connecting nodes to InputBusForNodes instances.
##
## Provides methods to safely connect Control nodes and other objects to input buses,
## with comprehensive error handling. Connection lifecycle is automatically managed by Godot's engine
## when nodes are deleted (free() / queue_free()).
##
## Example usage:
## [codeblock]
## var input_bus = InputBusForNodes.new()
## var result = InputBusUtils.connect_control(my_button, input_bus)
## if result != OK:
##     print("Failed to connect: " + str(result))
## [/codeblock]
class_name InputBusUtils
extends Object

## Connects a Control node to an InputBusForNodes.
##
## Connects the control's mouse_entered, mouse_exited, and gui_input signals to the input bus.
## Connection lifecycle is automatically managed by Godot's engine when the node is deleted.
##
## [param control]: The Control node to connect signals from.
## [param input_bus]: The InputBusForNodes instance to connect signals to.
## [return]: [OK] on success, [FAILED] if parameters are invalid.
static func connect_control(control: Control, input_bus: InputBusForNodes) -> Error:
	if _guard_clause_caught_error(control, input_bus): return FAILED
	
	control.mouse_entered.connect(input_bus.mouse_entered.emit.bind(control))
	control.mouse_exited.connect(input_bus.mouse_exited.emit.bind(control))
	control.gui_input.connect(input_bus.input_event.emit.bind(control))
	return OK

## Connects any object to an InputBusForNodes, with type detection and routing.
##
## Automatically detects Control objects and routes them to connect_control for proper signal handling.
## For unsupported object types, returns an error and logs the issue.
##
## [param object]: The object to connect (must be a Control for successful connection).
## [param input_bus]: The InputBusForNodes instance to connect signals to.
## [return]: [OK] on success, [FAILED] if parameters are invalid or object type is unsupported.
static func connect_object(object: Object, input_bus: InputBusForNodes) -> Error:
	if _guard_clause_caught_error(object, input_bus): return FAILED 
	
	# Check if object is a Control and use the specialized method
	if is_instance_of(object, Control):
		return connect_control(object as Control, input_bus)
	else:
		push_error("InputBusUtils: type not recognized: {0}".format([object.get_class()]))
		return FAILED

## Disconnects a Control node from an InputBusForNodes.
##
## Safely disconnects all previously connected signals. Note that manual disconnection is typically not needed
## as Godot's engine automatically handles connection cleanup when nodes are deleted.
##
## [param control]: The Control node to disconnect signals from.
## [param input_bus]: The InputBusForNodes instance to disconnect signals from.
## [return]: [OK] on success, [FAILED] if parameters are invalid.
static func disconnect_control(control: Control, input_bus: InputBusForNodes) -> Error:
	if _guard_clause_caught_error(control, input_bus): return FAILED
	
	control.mouse_entered.disconnect(input_bus.mouse_entered.emit.bind(control))
	control.mouse_exited.disconnect(input_bus.mouse_exited.emit.bind(control))
	control.gui_input.disconnect(input_bus.input_event.emit.bind(control))
	return OK

## Disconnects any object from an InputBusForNodes, with type detection and routing.
##
## Automatically detects Control objects and routes them to disconnect_control for proper signal cleanup.
## Note that manual disconnection is typically not needed as Godot's engine automatically handles
## connection cleanup when nodes are deleted.
##
## [param object]: The object to disconnect (must be a Control for successful disconnection).
## [param input_bus]: The InputBusForNodes instance to disconnect signals from.
## [return]: [OK] on success, [FAILED] if parameters are invalid or object type is unsupported.
static func disconnect_object(object: Object, input_bus: InputBusForNodes) -> Error:
	if _guard_clause_caught_error(object, input_bus): return FAILED
	
	# Check if object is a Control and use the specialized method
	if is_instance_of(object, Control):
		return disconnect_control(object as Control, input_bus)
	else:
		push_error("InputBusUtils: type not recognized: {0}".format([object.get_class()]))
		return FAILED

## Internal guard clause to validate input parameters.
##
## Checks if the provided object and input_bus are valid (not null) and logs an error if invalid.
##
## [param object]: The object to validate.
## [param input_bus]: The input bus to validate.
## [return]: [true] if validation failed (error was logged), [false] if parameters are valid.
static func _guard_clause_caught_error(object: Object, input_bus: InputBusForNodes) -> bool:
	if not object or not input_bus:
		push_error("InputBusUtils: object and input_bus cannot be null")
		return true 
	return false

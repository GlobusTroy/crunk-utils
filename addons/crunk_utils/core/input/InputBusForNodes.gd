# InputBusForNodes.gd
class_name InputBusForNodes
extends RefCounted
## Generic signal dispatcher for raw input events meant to centralize events from any number of related nodes. 
##
## Can be instantiated to capture and distinguish input events for different contexts. [br][br]
## Example usage: [br]
##
## Declare a member inside a service class for a system related to various nodes or components. [br]
## Inside service definition: [code]var input_bus : InputBusForNodes = InputBusForNodes.new()[/code] [br][br]
## Let the nodes/components discover the service and use InputTranslator methods to connect to the Bus 

## Raw input event signals. Ex: gui_input signal for a Control node
signal input_event(event: InputEvent, source: Node)

## Signal to trigger when the mouse hovers a node
signal mouse_entered(source: Node)

## Signal to trigger when the mouse stops hovering a node
signal mouse_exited(source: Node)

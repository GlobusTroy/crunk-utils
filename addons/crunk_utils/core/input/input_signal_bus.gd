class_name InputSignalBus
extends RefCounted

## Primitive input bus for reusable interaction systems.

signal mouse_down(source_node: Node, global_pos: Vector2, button_index: int)
signal mouse_up(source_node: Node, global_pos: Vector2, button_index: int)
signal mouse_entered(source_node: Node)
signal mouse_exited(source_node: Node)

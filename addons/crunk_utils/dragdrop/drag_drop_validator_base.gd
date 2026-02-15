class_name DragDropValidatorBase
extends Resource

## Base validator for drop operations. Can be configured to accept all or reject all.
## Extend this to create custom validation logic.

@export var accept_all: bool = true

func is_valid_drop(
	_draggable_component: Node,
	_dragged_target_node: Node
) -> bool:
	return accept_all

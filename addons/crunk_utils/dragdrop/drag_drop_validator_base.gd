class_name DragDropValidatorBase
extends Resource

## Abstract base for drop validators. Extend this to create custom validation logic.
## Default implementation accepts all drops.

func is_valid_drop(
	_draggable_component: DragDropDraggableComponent,
	_dragged_target_node: Node
) -> bool:
	return true

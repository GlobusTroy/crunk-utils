class_name DragDropColorValidator
extends DragDropValidatorBase

## Validates drops based on the dragged node's color property.
## Use with ColorRect or any CanvasItem with a color/modulate property.

enum BasePolicy {
	ACCEPT_ALL,  ## Accept all colors except those in color_list
	REJECT_ALL   ## Reject all colors except those in color_list
}

@export var base_policy: BasePolicy = BasePolicy.ACCEPT_ALL
@export var color_list: Array[Color] = []


func is_valid_drop(
	_draggable_component: DragDropDraggableComponent,
	dragged_target_node: Node
) -> bool:
	var dragged_color: Color = _get_color(dragged_target_node)
	var in_list: bool = _color_in_list(dragged_color)

	match base_policy:
		BasePolicy.ACCEPT_ALL:
			return not in_list  # Accept unless in exclusion list
		BasePolicy.REJECT_ALL:
			return in_list  # Reject unless in inclusion list
	return false


func _get_color(node: Node) -> Color:
	if node is ColorRect:
		return node.color
	if node is CanvasItem:
		return node.modulate
	return Color.BLACK


func _color_in_list(check_color: Color) -> bool:
	for list_color: Color in color_list:
		if check_color.is_equal_approx(list_color):  # Use approx for float safety
			return true
	return false

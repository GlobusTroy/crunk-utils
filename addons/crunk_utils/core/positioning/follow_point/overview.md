# Follow Point System Overview (`follow_point`)

## Purpose

Provide a reusable movement helper that smoothly moves one node toward a target position or a target node.

## Component

### `FollowPointComponent` (`follow_point_component.gd`)
- **Type:** `Node`
- **Primary use:** Smooth drag-follow motion in drag/drop, but reusable elsewhere.

## Key API

- `@export var apply_to_node: Node`
  - Node whose global position is updated.
  - Falls back to parent node when unset.

- `@export var target_node: Node`
  - Optional node to follow directly.
  - If set, target position resolves from this node.

- `@export var target_global_position: Vector2`
  - Fallback direct position when `target_node` is null.

- `set_target_node(node: Node)`
- `set_target_global_position(position: Vector2)`
- `start_following()` / `stop_following()`

## Behavior

1. Resolve target each frame:
   - `target_node` position when assigned
   - otherwise `target_global_position`
2. Read current global position of `apply_to_node`.
3. Lerp toward target using configured easing.
4. Write global position back to `apply_to_node`.

Supports both `Control` and `Node2D` style positioning behavior.

## Integration in Drag/Drop

- Controller creates/configures an instance for active drag items.
- During drag updates, controller updates follow target (or target node).
- On drop/end, controller stops and/or removes follow behavior.

## Design Boundary

- No drag/drop state or validation logic in this folder.
- This system should remain a generic motion utility.

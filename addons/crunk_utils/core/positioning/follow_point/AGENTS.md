# follow_point system

Purpose: Smoothly move a node toward a target point.

High-level design:
- `SmoothFollowComponent` performs interpolation toward target position.
- Component self-optimizes by disabling processing near target and re-enabling on new target.
- Keep this component focused on motion only; no drag/drop orchestration or validation.

# dragdrop system

Purpose: Own drag-and-drop orchestration, state, validation, and placement behavior.

High-level design:
- Coordinate lifecycle and thresholds with a dedicated coordinator/state machine.
- Use context-scoped input buses to isolate multiple drag/drop contexts.
- Enforce drops through composable rule resources and behavior components.
- Do not implement generic raw input primitives here; rely on `core/input/`.

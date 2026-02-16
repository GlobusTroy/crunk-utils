# crunk_utils Overview

This directory is organized into modular systems. Use this file as a routing index, then open the system-level `overview.md` for implementation details.

## Systems

1. **Core Input Abstractions** (`core/input`)
   - Provides reusable, low-level input signal primitives and translators.
   - Key components: `InputSignalBus`, `InputSignalTranslator`, `ControlInputSignalTranslator`.
   - Detailed guide: [`core/input/overview.md`](./core/input/overview.md)

2. **Drag & Drop System** (`dragdrop`)
   - Composes input primitives into drag/drop state, orchestration, marker components, validators, and strategies.
   - Key components: `DragDropInputBus`, `DragDropEventTranslator`, `DragDropSystemController`, draggable/receptor components, validators, strategies, `SmoothCenterContainer`.
   - Detailed guide: [`dragdrop/overview.md`](./dragdrop/overview.md)

3. **Follow Point Motion Utility** (`follow_point`)
   - Provides a reusable position-follow behavior for Controls/Node2D with optional target node following.
   - Key component: `FollowPointComponent`.
   - Detailed guide: [`follow_point/overview.md`](./follow_point/overview.md)

## Typical Integration Path

1. Wire input sources via core input translators.
2. Register draggable/receptor components with `DragDropSystemController`.
3. Let controller and translator coordinate drag/drop lifecycle.
4. Use `FollowPointComponent` for smooth drag-follow behavior.
5. Optionally apply validators and strategies for domain behavior/feedback.

## Notes for Agents

- Prefer class-based construction (`ClassName.new()`) for RefCounted/Object utilities.
- Keep system boundaries intact:
  - core/input = primitive input translation
  - dragdrop = drag/drop domain orchestration
  - follow_point = visual movement helper
- For detailed API contracts and flow, jump into each system’s local `overview.md`.

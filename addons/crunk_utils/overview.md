# crunk_utils — Addon Overview

crunk_utils is a modular Godot addon providing composable utilities for input translation, smooth positioning, and drag-and-drop orchestration. Each subsystem is independently usable — you can adopt `core/input/` without touching `dragdrop/`, or use `SmoothFollowComponent` in isolation. The design follows a composition-first philosophy: small, focused components wired together via signals rather than monolithic inheritance hierarchies.

---

## System Map

| System Path | Owns | Does NOT Own |
|---|---|---|
| `core/input/` | InputBus, InputTranslator, ControlTranslator | No drag/drop semantics |
| `core/positioning/follow_point/` | SmoothFollowComponent | No drag/drop state |
| `dragdrop/` | D&D orchestration, state, validation, strategies | No generic input primitives |

---

## Component Inventory

| Class | Base Class | Purpose | Owning System |
|---|---|---|---|
| `InputBus` | RefCounted | Signal dispatcher for raw input events | `core/input` |
| `InputTranslator` | Node | Wires engine input callbacks to an InputBus | `core/input` |
| `ControlTranslator` | InputTranslator | Routes `_gui_input` on Controls to InputBus | `core/input` |
| `SmoothFollowComponent` | Node | Interpolates position toward a target with auto-disable optimization | `core/positioning/follow_point` |
| `DragDropInputBus` | Context registry | Factory for per-context InputBus instances (see Design Note 4b) | `dragdrop` |
| `DraggableComponent` | Node | Tags a node as draggable, owns an internal translator | `dragdrop` |
| `ReceptorComponent` | Node | Tags a node as a drop target, holds exported DropValidator | `dragdrop` |
| `DragDropSystemCoordinator` | Node | State machine tracking drag lifecycle and thresholds | `dragdrop` |
| `DragDropBehavior` | Node | Executes scene tree manipulations on drop events | `dragdrop` |
| `DropRule` | Resource (abstract) | `can_drop(draggable: Node) -> bool` | `dragdrop` |
| `AcceptAllRule` | Resource | Concrete rule — always accepts | `dragdrop` |
| `PropertyMatchRule` | Resource | Concrete rule — matches on exported property | `dragdrop` |
| `OccupancyRule` | Resource | Concrete rule — checks slot occupancy | `dragdrop` |
| `CompositeRule` | Resource | Concrete rule — composes multiple DropRules | `dragdrop` |

---

## Design Notes

### 4a. `_gui_input` vs `_unhandled_input` — Gotcha

`ControlTranslator` hooks `_gui_input` deliberately. This means UI drag events are consumed within the Control tree and do **not** leak to `_unhandled_input` game-world handlers. This is correct behavior.

**Overlapping Draggables gotcha:** When Controls overlap, only the topmost (by draw order) receives `_gui_input`. Controls underneath are occluded. This is not a bug — it is Godot's `mouse_filter` system. Scene authors must set `mouse_filter` intentionally (`MOUSE_FILTER_STOP` vs `MOUSE_FILTER_PASS`) on Draggable Controls.

**Do NOT** try to route drag-start events through `_unhandled_input` to "fix" stacking — this causes cross-context event leakage which is far worse.

### 4b. Singleton vs Context Registry — Refinement

A naive singleton `DragDropInputBus` holding one `InputBus` instance fails when multiple D&D contexts coexist (e.g., inventory + world map).

**Refinement:** `DragDropInputBus` becomes a context registry.
- API: `DragDropInputBus.get_context(context_id: StringName) -> InputBus`
- Components export a `context_id: StringName` (default `&"default"`)
- Cleanup contract: Coordinator calls `DragDropInputBus.release_context()` on `_exit_tree` to prevent leaks.

---

## Improvements / Gotchas

1. **Overlapping Draggable Controls** — `mouse_filter` configuration is the scene author's responsibility, not auto-handled by the component. This preserves single-responsibility.
2. **SmoothFollowComponent self-optimization contract** — Calls `set_process(false)` when within epsilon of target, re-enables on new target assignment. External code must **not** call `set_process()` on this component or it will break reactivation.

---

## Cross-System Wiring Overview

The signal chain for a drag-and-drop interaction flows through all three systems:

`ControlTranslator` → `InputBus` → `DragDropSystemCoordinator` → `DragDropBehavior` → `DropValidator`

The input layer (`ControlTranslator`) captures raw GUI events and emits them through an `InputBus`. The drag-drop coordinator listens to that bus, manages lifecycle state (idle → dragging → dropping), and delegates final placement to `DragDropBehavior`, which consults the target's `DropValidator` (composed of `DropRule` resources) before executing scene tree changes. Each link in the chain only knows about its immediate neighbors — no component reaches across system boundaries.

---

## Per-System Documentation

- [`core/input/overview.md`](core/input/overview.md)
- [`core/positioning/follow_point/overview.md`](core/positioning/follow_point/overview.md)
- [`dragdrop/overview.md`](dragdrop/overview.md)

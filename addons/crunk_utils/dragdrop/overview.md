# Drag & Drop System Overview (`dragdrop`)

## Purpose

Build drag/drop behavior on top of primitive input signals with clear separation between:
- input event translation,
- state transitions,
- scene orchestration,
- drop validation,
- visual/behavioral strategy.

## Core Runtime Components

### `DragDropInputBus` (`drag_drop_input_bus.gd`)
- **Role:** Provides drag/drop-scoped access to a shared `InputSignalBus`.
- **Contract:** Singleton-style access point; no drag logic.

### `DragDropEventTranslator` (`drag_drop_event_translator.gd`)
- **Type:** `RefCounted`
- **Role:** Converts primitive input events into drag/drop semantic signals and state.
- **Responsibilities:**
  - register/unregister draggables and receptors
  - track active draggable
  - determine hover receptor
  - emit drag started/updated/drop requested events
- **Contract:** Pure interaction state machine; no reparenting or visual side effects.

### `DragDropSystemController` (`drag_drop_system_controller.gd`)
- **Type:** `Node`
- **Role:** Orchestrates scene mutations from translator events.
- **Responsibilities:**
  - receive drag/drop semantic events
  - manage active drag origin/return behavior
  - perform reparenting on valid drop
  - drive `FollowPointComponent` during active drag
  - emit high-level lifecycle signals for strategies

## Marker/Component Layer

### Draggable Components
- `DragDropDraggableBaseComponent` (`drag_drop_draggable_component.gd`)
- `DragDropDraggableControlComponent` (`drag_drop_draggable_control_component.gd`)

**Responsibilities:**
- identify drag target and input source node
- create/bind input translators
- register with controller on lifecycle enter/exit

### Receptor Components
- `DragDropReceptorBaseComponent` (`drag_drop_receptor_component.gd`)
- `DragDropReceptorControlComponent` (`drag_drop_receptor_control_component.gd`)

**Responsibilities:**
- expose receptor input source node
- validate `can_accept(...)` using validator(s)
- provide drop container target
- control specialization auto-provisions `SmoothCenterContainer` when needed

## Validation Layer

- `DragDropValidatorBase` (`drag_drop_validator_base.gd`)
- Example: `DragDropColorValidator` (`drag_drop_color_validator.gd`)

**Contract:** Reusable drop-acceptance policy independent of input and orchestration.

## Strategy Layer

- `DragDropSystemStrategyBase` (`drag_drop_system_strategy_base.gd`)
- `DragDropBasicStrategy` (`drag_drop_basic_strategy.gd`)

**Role:** Subscribe to controller lifecycle signals and apply project-specific feedback/animation behavior.

## Utility Node

### `SmoothCenterContainer` (`smooth_center_container.gd`)
- **Role:** Keeps dropped controls visually centered/aligned in receptor containers.
- **Usage:** Often auto-created by receptor control components.

## End-to-End Flow

1. Draggable/receptor components register with controller and translator.
2. Input translators emit primitive events into `InputSignalBus`.
3. `DragDropEventTranslator` updates drag state and emits semantic events.
4. `DragDropSystemController` executes scene operations and emits lifecycle signals.
5. Validators and strategies apply acceptance rules + presentation behavior.

## Design Constraints

- Keep state machine side-effect free (translator).
- Keep scene mutations in controller.
- Keep policies in validators.
- Keep visuals/UX in strategies and helper components.

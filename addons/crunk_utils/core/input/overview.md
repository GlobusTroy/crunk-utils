# Core Input System Overview (`core/input`)

## Purpose

Provide reusable, primitive input events that higher-level systems (like drag/drop) can consume without coupling to scene-specific UI code.

## Components

### `InputSignalBus` (`input_signal_bus.gd`)
- **Type:** `RefCounted`
- **Role:** Event bus for primitive pointer/mouse events.
- **Signals:**
  - button down/up
  - pointer moved
  - hover entered/exited
- **Contract:** Stateless transport layer; no drag/drop semantics.

### `InputSignalTranslator` (`input_signal_translator.gd`)
- **Type:** `RefCounted` base class
- **Role:** Lifecycle wrapper for binding/unbinding node signals into an `InputSignalBus`.
- **Contract:**
  - `bind(...)` wires node events to the bus.
  - `unbind()` disconnects safely.
  - Subclasses implement source-specific wiring.

### `ControlInputSignalTranslator` (`control_input_signal_translator.gd`)
- **Type:** `InputSignalTranslator` subclass
- **Role:** Adapts `Control` signals (`gui_input`, `mouse_entered`, `mouse_exited`) into `InputSignalBus` events.
- **Contract:** Emits only primitive events; does not track drag state.

## Data Flow

1. A UI source node (`Control`) receives native Godot input.
2. `ControlInputSignalTranslator` maps those events to bus signals.
3. Any system with bus access consumes those normalized events.

## Extension Points

- Add additional translators for other node types while keeping `InputSignalBus` stable.
- Add new primitive signals to `InputSignalBus` only when broadly reusable.

## Boundaries

- No drag/drop policy, receptor logic, validators, or visual behavior here.
- This folder should remain generic and reusable across interaction systems.

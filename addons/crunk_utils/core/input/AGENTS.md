# core/input system

Purpose: Translate engine/control input into normalized signals.

High-level design:
- `InputBus` dispatches raw input events.
- Translators (`InputTranslator`, `ControlTranslator`) adapt Godot callbacks into bus events.
- Keep this layer input-primitive only; do not add drag/drop semantics here.

# Crunk Utils Architecture Guidelines

## System Boundaries

- **core/input**: Only primitive input translation. No drag/drop semantics.
- **dragdrop**: Drag/drop orchestration, state, validation, strategies. No generic input primitives.
- **follow_point**: Generic motion helper. No drag/drop state.

## Cross-System Contracts

- Use class-based construction (`ClassName.new()`) for RefCounted utilities.
- Avoid hardcoded script paths (`res://...`) in favor of referencingclass_name.
- Prefer strong typing over Object-typed dynamic calls.

## File Organization

- Each system directory contains its own `overview.md` for detailed contracts.
- Top-level `overview.md` provides routing and brief component map.
- Keep component responsibilities aligned with their system's purpose.

## When Adding Features

1. Identify which system owns the responsibility.
2. Reference that system's `overview.md` for API contracts.
3. Do not leak responsibilities across system boundaries.

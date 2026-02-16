# core system

Purpose: Shared foundational utilities used by higher-level systems.

High-level design:
- Keep this layer generic and reusable.
- Contain low-level primitives (input and positioning), not game-specific behavior.
- Avoid drag/drop orchestration logic here; that belongs in `dragdrop/`.

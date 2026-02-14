# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

CrunkUtils is a reusable Godot 4.6 addon library written in GDScript. The main addon lives in `addons/crunk_utils/`. The project uses GL Compatibility rendering and Jolt Physics.

## Development

- **Engine:** Godot 4.6 (open project in Godot Editor to develop)
- **Plugin management:** gd-plug — dependencies declared in `plug.gd`
- No build step, test runner, or linter is configured

## GDScript Coding Standards

- Statically type all variables
- Define and use enums rather than strings for constants
- Use `@export var node_name: SpecificNodeType` for scene node dependencies (not `get_node()`)
- Prefer composition over inheritance for new systems
- Minimize coupling; enforce separation of concerns and single responsibility
- Review existing classes for reuse before duplicating functionality

## Architecture: Drag & Drop System (`addons/crunk_utils/dragdrop/`)

The drag-and-drop system uses a **component pattern with signal-based communication**:

- **DragDropSystemController** — Central hub managing global drag state. Uses group-based auto-registration (`"drag_drop_system_controllers"` group). Coordinates all drag/drop/hover signals between draggables and receptors.
- **DraggableNodeBase / DraggableControlComponent** — Base class and Control-specific implementation for draggable items. Tracks drag state (NOT_DRAGGING → BEGINNING_DRAG → DRAGGING) with configurable `drag_start_distance`. Auto-registers with controller on `_ready()`.
- **ReceptorNodeBase / ReceptorControlComponent** — Base class and Control-specific implementation for drop targets. Override `can_receive_drop()` for validation logic. Auto-registers with controller.

Key patterns:
- Components auto-register on `_ready()` and deregister on `_exit_tree()`
- All events flow through signals, keeping components decoupled
- Controller is discovered via node groups, not direct references

## Third-Party Addons

- `addons/gd-plug/` and `addons/gd-plug-ui/` — Plugin manager (do not edit)
- `addons/maaacks_menus_template/` — Window/menu nodes from Godot-Menus-Template (do not edit)

# GDScript Coding Guidelines

- Static Typing: Always statically type every variable. Ex: `var x: Type` or `var x: Type = value`
- Class References: Never reference class types by script path (e.g. `extends "res://..."` for class typing). Always use native `class_name` references.
- Type Safety: use enums for constants and avoid magic strings
- Node Access: use `@export var nodeName: NodeType` for scene dependencies, avoid get_node() or hardcoded paths
- Decoupling: Prefer signals for upwards or complex communications and methods for downward communication
- Composition over Inheritance: Favor composition over deep inheritance
- Base classes: In the following cases strictly extend the following base classes:
  - Use Resource as the base class for any data container ex: ui state, scene, or game logic data.
  - Use Node as the base class for a 'component' node used to add functionality to a parent node
  - Use Node as the base class for an orchestrator class that lives in the scene tree and is involved in the engine's lifecycle (ready, process, physics_process, _input, etc.) 
- Consult godot-docs or godot-tools/godot-docs MCP to understand any built-in classes being used

---
trigger: glob
globs: **/*.gd
---

# GDScript Coding Guidelines 
- Statically type all variables
- Define and use enums rather than using strings for constant
- Use @godot-docs MCP to refer to documentation for best practices before using builtin classes
- Enforce separation of concerns and single responsibility principle
- When requiring a node dependency from the scene, use ```@export var node_name : SpecificNodeType``` rather than node paths or get_node()
- Prefer composition over inheritance for new systems
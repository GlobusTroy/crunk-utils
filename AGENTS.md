# Project Documentation Reference

## Reference Triggers

### When editing ANY .gd file
- When writing gdscript, reference: **docs/gdscript-style-guide.md** for GDScript coding standards and best practices

### When reasoning about or referring to any builtin Godot class
- When working or reasoning about or referring to any builtin Godot class, always reference **docs/godot-documentation-reference.md** and get the latest documentation as ground truth following the guidelines within

### Make use of godot-tools mcp server 
- When editing or getting information on any scene, .tscn file, resource, .tres file, or Godot project file or setting, make use of godot-tools mcp server rather than editing files directly
- When testing the project, use the godot-tools mcp server to run the project and inject input and get live debugging information from the editor or engine as needed, including to get screenshots, and read errors, logs, and output

## When researching or reasoning about a common topic 
- Reference specific tutorial documents when working with:
- - **General**: Best practices, editor usage, troubleshooting → `docs/tutorials/general-tutorials.md`
- - **Scripting**: GDScript basics, signals, scene management, resources → `docs/tutorials/scripting-tutorials.md`
- - **UI**: User interfaces, controls, containers, themes, GUI design → `docs/tutorials/ui-tutorials.md`

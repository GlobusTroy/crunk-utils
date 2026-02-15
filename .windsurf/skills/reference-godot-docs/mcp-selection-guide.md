# MCP Server Selection Guide

## MCP Server Selection Criteria

### Use godot-docs MCP for:
- **Readable documentation** with explanations and tutorials
- **Specific sections** (description, properties, methods, signals) 
- **Tutorial pages** and best practice guides
- **Targeted lookups** when you need specific information efficiently
- **Explanation pages** for optimization, best practices, and tutorials

### Use godot-tools MCP for:
- **Comprehensive API reference** with complete property listings
- **Full class reference** when multiple sections needed (properties + methods + signals + description)

## MCP Tool Usage Strategy

### Token-Efficient Queries:
1. **godot-docs**: Always specify sections - `description`, `properties`, `methods`, `signals`
2. **Query only active nodes/classes** - don't fetch documentation for unused elements
3. **Topic-specific queries** for tutorials directly related to current task
4. **Avoid full documentation** unless specifically requested

### When to Use Each MCP:

#### godot-docs MCP Commands:
```gdscript
# For specific sections
mcp0_godot_docs(action="fetch_class", class_name="Control", section="description")
mcp0_godot_docs(action="fetch_class", class_name="Control", section="properties")
mcp0_godot_docs(action="fetch_class", class_name="Control", section="methods")
mcp0_godot_docs(action="fetch_class", class_name="Control", section="signals")

# For tutorials and guides
mcp0_godot_docs(action="fetch_page", path="/tutorials/ui/ui_containers.html")
```

#### godot-tools MCP Commands:
```gdscript
# For comprehensive reference
mcp0_get_godot_class(className="Control")
```

## Decision Matrix

| Information Need | Recommended MCP | Reason |
|-----------------|----------------|---------|
| Need explanation/tutorial | godot-docs | Better readability, tutorials available |
| Need specific property/method | godot-docs | Targeted section queries save tokens |
| Need complete API reference | godot-tools | Comprehensive property listings |
| Need multiple sections | godot-tools | Single call gets all information |
| Debugging specific method | godot-docs | Targeted method description |
| Learning new concept | godot-docs | Tutorial and explanation pages |
| Implementing complex feature | godot-tools | Full reference needed |

## Query Examples

### Targeted Queries (godot-docs):
- "What are the properties of Control node?"
- "Show me the methods for RefCounted class"
- "Explain Resource class description"
- "Tutorial on UI optimization"

### Comprehensive Queries (godot-tools):
- "Show me everything about Control node"
- "Complete reference for Resource class"
- "All properties and methods for Node2D"

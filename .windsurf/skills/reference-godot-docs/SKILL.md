---
name: reference-godot-docs
description: Always reference official Godot documentation whenever working with Godot nodes, classes, or implementing game mechanics. Provides query guidance and criteria for MCP server selection and should be invoked whenever working with Godot.
---

# Godot Documentation Reference Skill

## Context Analysis

Before making any MCP documentation calls, determine if official Godot documentation is already available in the current context:

### Check for Existing Documentation:
- **Information Sufficiency**: Does the current context contain documentation for the Godot class/node being used?
- **Tutorial/Explanation Pages**: Is a common topic being impelemented? If so, has a relevant guide from the docs been retrieved in the current context yet? 

## Decision Criteria

### Make MCP Calls When:
- ❌ No direct documentation already retrieved for the Godot class/node being used 
- ❌ No relevant tutorials have been retrieved and cover the topic 
### Skip MCP Calls When:
- ✅ Direct documentation already retrieved for the Godot class/node being used 
- ✅ Relevant tutorials have been retrieved and cover the topic

## Documentation Retrieval

If MCP calls are required based on the criteria above:

1. **Select MCP server**: Use `mcp-selection-guide.md` for optimal server choice
2. **Execute targeted queries**: Follow token-efficient strategies

## Manual Invocation
Use `@reference-godot-docs` when you want to ensure documentation analysis and retrieval is performed for Godot-related questions.

## Examples:
- "@reference-godot-docs Which UI container should I use for this layout?"
- "@reference-godot-docs What are some common optimizations using Servers in godot?"
- "Which signals can I connect to on a button?"
- "What methods let me update all the children of an HBoxContainer?"

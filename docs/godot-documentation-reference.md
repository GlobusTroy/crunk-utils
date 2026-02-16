# Godot Documentation Reference Guide

## Context Analysis

Before making any MCP documentation calls, determine if official Godot documentation is already available in the current context:

### Check for Existing Documentation:
- **Information Sufficiency**: Does the current context contain documentation for the Godot class/node being used? If not, DO retrieve documentation from MCP 
- **Tutorial/Explanation Pages**: Is a common topic being implemented? If so, has a relevant guide from the docs been retrieved in the current context yet; If not, DO retrieve documentation from MCP

## Documentation Retrieval

If MCP calls are required based on the criteria above:

1. **Select MCP server**: Use the appropriate MCP server for your needs:
   - `godot-tools` (@satelliteoflove/godot-mcp) - For partial documentation fetches, tutorials/guides, and specific sections
   - `godot-documentation-reference` (@fernforestgames/mcp-server-godot-docs) - For complete documentation access and searching

2. **Execute targeted queries**: Follow token-efficient strategies

## MCP Server Selection

### godot-tools MCP Server (@satelliteoflove/godot-mcp)
- Use for: Partial documentation fetches, tutorials/guides, and specific sections
- Functions: 
  - `mcp0_godot_docs` - Fetch Godot Engine documentation with smart extraction
    - `fetch_class` - Get class references (e.g. CharacterBody2D) with specific sections
    - `fetch_page` - Get tutorials/guides by documentation path
    - Supports sections: `full`, `description`, `properties`, `methods`, `signals`
- Best for: Getting specific parts of class documentation, tutorials, and guides when you don't need the complete class reference

### godot-documentation-reference MCP Server (@fernforestgames/mcp-server-godot-docs)
- Use for: Complete documentation access and searching
- Functions: 
  - `mcp0_search_godot_docs` - Search the Godot engine documentation for classes, methods, properties, signals, and constants
  - `mcp0_get_godot_class` - Get the full documentation for a specific Godot class, including all methods, properties, signals, and constants
- Best for: Searching when unsure about class existence, getting complete class references

## Usage Strategy:
1. **If unsure about class existence**: Use `mcp0_search_godot_docs` from godot-documentation-reference
2. **For complete class reference**: Use `mcp0_get_godot_class` from godot-documentation-reference  
3. **For partial class info or specific sections**: Use `mcp0_godot_docs` with `fetch_class` from godot-tools
4. **For tutorials/guides**: Use `mcp0_godot_docs` with `fetch_page` from godot-tools

## Usage Examples:
- "Search for Button class" → `mcp0_search_godot_docs` (godot-documentation-reference)
- "Get full CharacterBody2D documentation" → `mcp0_get_godot_class` (godot-documentation-reference)
- "Get just the methods for Button" → `mcp0_godot_docs` with fetch_class + methods section (godot-tools)
- "Find 2D movement tutorial" → `mcp0_godot_docs` with fetch_page (godot-tools)

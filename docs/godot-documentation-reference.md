# Godot Documentation Reference Guide

## Context Analysis

- **Information Sufficiency**: Does the current context contain the latest documentation for immediately relevant information on the Godot class being used? If not, DO retrieve documentation from MCP 

## Documentation Retrieval

1. **Select MCP server**: Use the appropriate MCP server for your needs:
   - `godot-documentation-reference` (@fernforestgames/mcp-server-godot-docs) - For complete documentation access and searching
   - `godot-tools` (@satelliteoflove/godot-mcp) - For partial documentation fetches and specific sections

2. **Execute targeted queries**: Follow token-efficient strategies

### godot-documentation-reference MCP Server (@fernforestgames/mcp-server-godot-docs)
- Use for: Complete documentation access and searching
- Functions: 
  - `mcp0_search_godot_docs` - Search the Godot engine documentation for classes, methods, properties, signals, and constants
  - `mcp0_get_godot_class` - Get the full documentation for a specific Godot class, including all methods, properties, signals, and constants
- Best for: Searching when unsure about class existence, getting complete class references

### godot-tools MCP Server (@satelliteoflove/godot-mcp)
- Use for: Partial documentation fetches and specific sections
- Functions: 
  - `mcp0_godot_docs` - Fetch Godot Engine documentation with smart extraction
    - `fetch_class` - Get class references (e.g. CharacterBody2D) with specific sections
    - Supports sections: `full`, `description`, `properties`, `methods`, `signals`
- Best for: Getting specific parts of class documentation when you don't need the complete class reference

## Usage Strategy:
1. **If unsure about class existence**: Use `mcp0_search_godot_docs` from godot-documentation-reference
2. **For complete class reference**: Use `mcp0_get_godot_class` from godot-documentation-reference  
3. **For partial class info or specific sections**: Use `mcp0_godot_docs` with `fetch_class` from godot-tools

## Usage Examples:
- "What existing Container nodes are there?" → `mcp0_search_godot_docs` (godot-documentation-reference)
- "How does CharacterBody2D work?" → `mcp0_get_godot_class` (godot-documentation-reference)
- "Which method should I override on CharacterBody2D?" → `mcp0_godot_docs` with fetch_class + methods section (godot-tools)
- "What signals does Control have?" → `mcp0_godot_docs` with fetch_class + signals section (godot-tools)

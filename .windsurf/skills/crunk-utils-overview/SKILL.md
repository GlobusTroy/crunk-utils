---
name: crunk-utils-overview
description: Provides context-aware crunk_utils system overviews when working in the crunk_utils directory. Automatically surfaces the relevant overview.md for the current system and top-level routing.
---

# crunk_utils Overview Skill

## Context Analysis

When working in the crunk_utils directory tree, provide the appropriate system overview to guide implementation decisions.

## Directory-to-Overview Mapping

### Top-level (`addons/crunk_utils/`)
- Provide: `addons/crunk_utils/overview.md`
- Use case: Understanding overall system boundaries and where to go for details

### System Directories
- `addons/crunk_utils/core/input/` → `addons/crunk_utils/core/input/overview.md`
- `addons/crunk_utils/dragdrop/` → `addons/crunk_utils/dragdrop/overview.md`
- `addons/crunk_utils/follow_point/` → `addons/crunk_utils/follow_point/overview.md`

## When to Invoke

### Automatic Invocation
- When the active file or workspace is within a crunk_utils system directory
- Before making architectural changes to a system
- When adding new components to a system

### Manual Invocation
Use `@crunk-utils-overview` when you want to:
- Refresh understanding of current system boundaries
- Verify which component owns a specific responsibility
- Get a quick reference for API contracts in the current system

## Usage Pattern

1. Detect current working directory within crunk_utils
2. Load the corresponding overview.md file
3. Provide relevant architectural context for the task
4. Reference specific component responsibilities and boundaries

## Examples

- "@crunk-utils-overview I'm adding a new validator to dragdrop"
- "@crunk-utils-overview Which component handles input translation?"
- "@crunk-utils-overview Show me the dragdrop system boundaries"

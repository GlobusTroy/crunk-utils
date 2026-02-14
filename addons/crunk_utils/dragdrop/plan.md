# DragDrop System Plan

## Overview
This document outlines the design and implementation plan for a flexible, reusable drag and drop system in Godot using GDScript.

## Functional Requirements

### Core Features
- Be able to easily add 'draggable' component to any node to make the object able to be dragged between docks/receptors
- Be able to easily add 'receptor' component to any node to make the object able to receive dragged object
- Flexibly handle response to dragging events for extensibility, use signals to convey important input information
- Toggleable default behaviors

### Default Behaviors
- When dragging, the dragged object should smoothly follow the cursor with an adjustable easing factor
- Draggable nodes should smoothly snap into place when dropped to a new receptor
- Draggable nodes should smoothly return to their original position when dropped outside of a receptor

### Extensibility and Hooks
- Provide signals for key events (drag start, drag end, drop, etc.)
- Use an extendable 'abstract' manager node to handle temporary global drag state, with sensible examples for the default behavior 
- Use the attachable nodes for to "mark" an object and utilize Control event hooks to send input events to the SystemController and allow the logic to be handled in the SystemController

## Technical Implementation

### Architecture
- DragDropSystemController - The main system controller that manages global drag state and coordinates between draggable and receptor nodes.
- - Manages temporary dragging state and translates the component's drag/drop events into system-level actions when a draggable node is dropped into a valid receptor 
- - Provides signals for key events (drag start, drag end, drop, etc.)
- - Handles signals from component nodes; central registry for the system
- - Checks receptor can_receive_drop to properly translate ui actions to system events/signals
- DragDropDraggableComponent - Abstract base class that defines draggable signals and interface
-  - Defines required signals: drag_started, drag_ended
-  - Signals include the parent/control node that is being dragged
-  - Abstract methods for starting/ending drag operations
-  - Register with the DragDropSystemController on _ready
- DragDropDraggableControlComponent - Control-based implementation of DragDropDraggableComponent
-  - @export target_control: Control (defaults to parent)
-  - Throw warning or error if target_control is not a Control node
-  - Use parent control's gui_input signal to handle mouse events
-  - Configurable drag_start_distance threshold to prevent accidental drags
-  - Disables _unhandled_input when NOT_DRAGGING for performance
- DragDropReceptorComponent - Abstract base class that defines receptor signals and interface
-  - Defines required signals: receptor_hover_start, receptor_hover_end
-  - Signals include the receptor parent/control node
-  - Defines virtual method: can_receive_drop(draggable, target_node) -> bool
-  - Register with the DragDropSystemController on _ready
- DragDropReceptorControlComponent - Control-based implementation of DragDropReceptorComponent
-  - @export target_control: Control (defaults to parent)
-  - Throw warning or error if target_control is not a Control node
-  - Uses mouse_entered/mouse_exited signals from target Control
-  - Implements can_receive_drop with default validation (can be overridden)
- DragDropSystemStrategyBase - Abstract base class for drag drop system strategies
-  - Auto-discovers controller via group or @export reference
-  - Connects to all controller signals and provides virtual handler methods
- DragDropBasicStrategy - Default strategy with standard drag/drop behaviors
-  - Dragged node follows cursor with configurable easing (follow_easing)
-  - Dragged node tweens to receptor position on valid drop (snap_duration)
-  - Dragged node tweens back to origin on invalid drop or drag end (return_duration)

# Input Machine Overview

## InputMachine
- InputMachine is a Node class that implements a node-based state machine.
- InputMachine is the top level node and manages the state machine
- InputMachine tracks the active state (child node) and forwards basic input events to the active state 
- InputMachine is added to the scene tree in the editor for scenes that require complex 2d input handling

### Input Machine Responsibilities 
- InputMachine connects to the active state's transition signal and handles state transitions
- InputMachine calls lifecycle methods: enter_state and exit_state on state transitions
- InputMachine uses a Physics Point Query at mouse position to detect overlapping Area2D nodes every frame using the collision mask of the active state
- InputMachine tracks hovered nodes and emits hover_start and hover_end signals
- InputMachine emits mouse_up, mouse_down, and mouse_clicked signals for overlapping nodes
- InputMachine emits mouse_motion for the mouse position
- InputMachine should have a default state when a null or invalid transition is made

## InputMachineState 
- InputMachineState is a Node class that implements a state for an InputMachine node-based state machine.
- InputMachineState is added as a child of InputMachine 
- InputMachineState does not need a reference to the InputMachine
- InputMachineState should use exported variables to reference "next state" nodes

### InputMachineState Responsibilities
- InputMachineState must have a collision_mask property to define relevant entities for input events
- InputMachineState handles mouse events from InputMachine and emits game event signals from a GameEventBus that defines the input signals / player intents to respond to in terms of the game logic
- InputMachineState must implement enter_state and exit_state lifecycle methods

## Example Usage

### Drag and Drop Input Machine
- InputMachine 
- - DragBaseState 
- - - (collision_mask can pick any draggable area2d) 
- - - mouse down on a draggable area2d -> emit "draggable_pressed", transition to PreDragState
- - PreDragState (collision_mask can pick any area2d)
- - DragState (collision_mask can pick any area2d)
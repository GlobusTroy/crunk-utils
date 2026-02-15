# Drag-Drop Demo - Test Guide

This demo showcases the drag-drop system with color-based validation.

## Layout

**Top Row (Draggables):** Red, Blue, Green, Yellow squares (80x80px)
**Bottom Row (Receptors):** Red, Blue, Green receptors + gray "Any" receptor (120x120px)

## Test Cases

### 1. Valid Drop - Matching Colors

| Drag | To | Expected |
|------|----|----------|
| Red square | Red receptor | Green tint while hovering -> Snaps to receptor on release |
| Blue square | Blue receptor | Green tint -> Snaps |
| Green square | Green receptor | Green tint -> Snaps |

Pass: Dragged item smoothly animates to center of receptor

### 2. Invalid Drop - Mismatched Colors

| Drag | To | Expected |
|------|----|----------|
| Red square | Blue receptor | Red tint while hovering -> Returns to origin on release |
| Blue square | Green receptor | Red tint -> Returns |
| Any color | Wrong receptor | Red tint -> Returns |

Pass: Dragged item smoothly returns to its starting position

### 3. "Any" Receptor - Accepts All

| Drag | To | Expected |
|------|----|----------|
| Yellow square | Gray "Any" receptor | Green tint -> Snaps |
| Red/Blue/Green | Gray "Any" receptor | Green tint -> Snaps |

Pass: Any color snaps to the gray receptor

### 4. Drop on Empty Space

| Action | Expected |
|--------|----------|
| Drag any square, release on background | Returns to origin |

Pass: Item smoothly returns to starting position

### 5. Hover Feedback (No Drag)

| Action | Expected |
|--------|----------|
| Mouse over any draggable square | Square scales up slightly (1.1x) |
| Mouse leaves draggable | Square returns to normal size |

Pass: Subtle scale animation on hover

### 6. Z-Index During Drag

| Action | Expected |
|--------|----------|
| Drag a square over other squares | Dragged item renders on top of everything |
| Release | Z-index returns to normal |

Pass: Dragged item always visible during drag

### 7. Cursor Following

| Action | Expected |
|--------|----------|
| Click and drag any square | Square follows cursor with slight easing (not instant) |

Pass: Smooth cursor following, not jittery

## How to Run

1. Open `dragdrop_demo.tscn` in Godot Editor
2. Press F5 or click Play
3. Work through each test case above

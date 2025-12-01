# Controls

Game controls for the Godot 4 2D Platformer Builder.

## Player Selection Screen

### Keyboard Navigation
- **Arrow Keys** (←/→ or ↑/↓): Navigate between player type options
- **ENTER** or **SPACE**: Start the game with selected player

### Mouse Controls
- **Click**: Select player type button
- **Click "Start Game"**: Begin playing

### Visual Feedback
- Selected option is highlighted with arrows: → Player ←
- Selected button has brighter color
- Hover effects on mouse-over

## Platformer Gameplay

### Movement
- **Left Arrow** or **A**: Move left
- **Right Arrow** or **D**: Move right
- Character sprite automatically flips to face movement direction

### Jumping
- **SPACE**: Jump
- **UP Arrow**: Jump (alternative)
- **W**: Jump (WASD alternative)

**Jump Mechanics:**
- Can only jump when on the ground (`is_on_floor()`)
- Jump height: ~250 pixels
- Jump velocity: -700 pixels/second
- Gravity: 980 pixels/second²

### Physics Behavior
- **Gravity**: Automatically pulls player downward
- **Friction**: Player slows to stop when no input
- **Air Control**: Full horizontal control while jumping
- **Collision**: Cannot jump through platforms from below

## Game Over / Victory

### Restart Controls
- **SPACE**: Restart game
- **ENTER**: Restart game
- **Arrow Keys** (any): Restart game

Press any of these keys when game over message appears.

## Input Actions

The following Godot input actions are used:

| Action | Keys | Purpose |
|--------|------|---------|
| `ui_left` | Left Arrow, A | Move left |
| `ui_right` | Right Arrow, D | Move right |
| `ui_up` | Up Arrow, W | Alternative jump |
| `ui_accept` | SPACE, Enter | Primary jump/confirm |
| `ui_select` | SPACE | Menu selection |

## Advanced Controls

### Debug Controls

If you enable debug mode in the game manager:

- **F3**: Toggle debug info (if implemented)
- **F5**: Reload current scene (Godot editor)

### Development Controls

While in Godot editor:

- **F5**: Run project
- **F6**: Run current scene
- **F7**: Step into (debugger)
- **F8**: Pause/Resume
- **Ctrl+R**: Reload saved scenes

## Customizing Controls

To customize input mappings, edit `project.godot`:

```ini
[input]

ui_left={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":0,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":4194319,"physical_keycode":0,"unicode":0,"echo":false,"script":null)
, Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":0,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":65,"physical_keycode":0,"unicode":0,"echo":false,"script":null)
]
}
```

Or use the Godot editor:

1. **Project → Project Settings**
2. **Input Map** tab
3. Add/remove keys for each action

## Controller Support

To add gamepad support:

1. Open **Project Settings → Input Map**
2. Add joypad buttons to existing actions:
   - `ui_left`: Joypad Left / Left Stick Left
   - `ui_right`: Joypad Right / Left Stick Right
   - `ui_accept`: Joypad Button 0 (A/Cross)

Example code for analog stick:

```gdscript
# In player.gd
var direction = Input.get_axis("ui_left", "ui_right")
# This already works with both keyboard and gamepad!
```

## Accessibility

### Alternative Control Schemes

Consider these accessibility options:

**One-Handed Play:**
- Remap all controls to one side of keyboard
- Example: Arrow keys for movement, Right Shift for jump

**Single-Button Mode:**
- Auto-run enabled
- Single button (SPACE) for jump only

**Touch/Mobile:**
- Virtual joystick for movement
- Tap anywhere to jump
- Requires custom implementation

## Tips for Players

### Platforming Tips
1. **Running Jump**: Get a running start for longer jumps
2. **Edge Grabbing**: Jump at the peak to barely reach platforms
3. **Air Control**: Change direction mid-jump to adjust landing
4. **Double-Check**: Look before you leap to plan your route

### Speed Running
- Chain jumps together for momentum
- Know collectible locations to optimize route
- Practice perfect jumps to save time

### Beginners
- Take your time - no rush in endless mode
- Practice jumping on lower platforms first
- Learn the jump arc before attempting high platforms

## Common Issues

### Can't Jump
- **Cause**: Not on ground
- **Solution**: Land on a platform first

### Character Not Moving
- **Cause**: Game paused or player selection not complete
- **Solution**: Ensure you selected a character

### Jump Not High Enough
- **Cause**: Physics settings
- **Solution**: Adjust `jump_velocity` in `player.gd` (more negative = higher)

### Too Slippery
- **Cause**: Low friction
- **Solution**: Increase friction in `move_toward()` call in `player.gd`

## Next Steps

- [Platformer Physics](platformer.md) - Understand the physics system
- [Customization](customization.md) - Modify controls and physics
- [Quick Start](quick-start.md) - Generate and play your first game

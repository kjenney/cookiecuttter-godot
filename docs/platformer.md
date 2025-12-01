# Platformer Features

Complete guide to the platformer physics and mechanics.

## Physics System

### Gravity
- **Value**: 980 pixels/second²
- **Application**: Constant downward force when not on ground
- **Customization**: Edit `@export var gravity` in `player.gd`

### Jump Mechanics
- **Jump Velocity**: -700 pixels/second (upward impulse)
- **Maximum Height**: ~250 pixels
- **Ground Detection**: Uses `is_on_floor()` to prevent air-jumping
- **Customization**: Edit `@export var jump_velocity` in `player.gd`

### Horizontal Movement
- **Speed**: 300 pixels/second
- **Friction**: Automatic slowdown when no input
- **Air Control**: Full control while airborne
- **Customization**: Edit `@export var speed` in `player.gd`

## Camera System

### Following Camera
- **Type**: Camera2D attached to player node
- **Horizontal Tracking**: Follows player position
- **Vertical**: Fixed unless player moves significantly

### Look-Ahead Offset
- **Offset**: 200 pixels ahead of player
- **Purpose**: Better view of upcoming platforms
- **Smooth Motion**: Position smoothing at 5.0 speed

### Boundaries
- **Left Limit**: 0 pixels
- **Right Limit**: 3000 pixels (level width)
- **Top Limit**: 0 pixels
- **Bottom Limit**: 648 pixels (screen height)

## Platform Generation

### Ground Platform
- **Width**: 3000 pixels (full level)
- **Height**: 48 pixels
- **Position**: y=600
- **Color**: Green (grass-style: 0.4, 0.6, 0.3)
- **Type**: StaticBody2D

### Jump Platforms
- **Count**: 6-8 per level
- **Width**: 200 pixels (default)
- **Height**: 40 pixels
- **Spacing**: 400 pixels apart horizontally

### Height Variation
Platforms alternate between three heights:
- **Low**: y=450 (150px above ground)
- **Medium**: y=350 (250px above ground)
- **High**: y=250 (350px above ground)

## Collectible Placement

### Platform-Aware Positioning
- **Placement**: 100 pixels above platforms
- **Distribution**: Spread across jump platforms
- **Variation**: Slight horizontal offset for multiple per platform

## Movement Mechanics

### Running
- Press Left/Right arrows or A/D
- Sprite flips to face direction
- Plays "walk" animation when moving
- Plays "idle" animation when stopped

### Jumping
- Press SPACE, W, or UP arrow
- Only works when `is_on_floor()` returns true
- Applies upward velocity impulse
- Gravity takes over immediately after

### Falling
- Automatic when not on ground
- Velocity increases due to gravity
- Lands when collision detected with platform

## Collision Layers

### Player (CharacterBody2D)
- **Collision Layer**: 2
- **Collision Mask**: 1
- **Meaning**: Player is on layer 2, detects platforms on layer 1

### Platforms (StaticBody2D)
- **Collision Layer**: 1
- **Collision Mask**: 0
- **Meaning**: Platforms are on layer 1, don't check for collisions

### NPCs (Area2D)
- **Collision Layer**: 4
- **Collision Mask**: 2
- **Meaning**: NPCs detect player entering their area

## Physics Tuning

### Floaty Jump
Reduce gravity for more air time:
```gdscript
@export var gravity = 600.0  # Lower = floatier
```

### High Jump
Increase jump velocity:
```gdscript
@export var jump_velocity = -900.0  # More negative = higher
```

### Fast Movement
Increase speed:
```gdscript
@export var speed = 500.0  # Higher = faster
```

### Tight Controls
Adjust friction in `_physics_process`:
```gdscript
velocity.x = move_toward(velocity.x, 0, speed * 2)  # Faster stop
```

## Advanced Features

### Double Jump
Add this to `player.gd`:
```gdscript
var jumps_remaining = 2

func _physics_process(delta):
    if is_on_floor():
        jumps_remaining = 2
    
    if Input.is_action_just_pressed("ui_accept") and jumps_remaining > 0:
        velocity.y = jump_velocity
        jumps_remaining -= 1
```

### Wall Jump
Requires additional collision detection:
```gdscript
if is_on_wall() and Input.is_action_just_pressed("ui_accept"):
    velocity.y = jump_velocity
    velocity.x = -get_wall_normal().x * speed  # Push off wall
```

### Variable Jump Height
Hold jump button for higher jumps:
```gdscript
if Input.is_action_just_released("ui_accept") and velocity.y < 0:
    velocity.y *= 0.5  # Cut jump short
```

## Level Design Tips

### Platform Spacing
- **Easy**: 300-350 pixels apart
- **Medium**: 400-450 pixels apart  
- **Hard**: 500+ pixels apart

### Vertical Challenge
- **Easy**: Max 150 pixels high
- **Medium**: 200-250 pixels high
- **Hard**: 250+ pixels high (barely reachable)

### Collectible Placement
- Put collectibles on difficult platforms for optional challenge
- Place some on the ground for guaranteed points
- Use layouts to create interesting collection patterns

## Next Steps

- [Level Configuration](levels.md) - Create custom platform layouts
- [Controls](controls.md) - Understand player controls
- [Customization](customization.md) - Modify physics and mechanics

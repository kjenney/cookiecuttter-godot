# Customization Guide

Learn how to customize and extend your generated platformer game.

## Quick Customizations

### Change Player Speed

Edit `scripts/player.gd`:

```gdscript
@export var speed = 400.0  # Default: 300.0
```

Higher values = faster horizontal movement

### Change Jump Height

Edit `scripts/player.gd`:

```gdscript
@export var jump_velocity = -900.0  # Default: -700.0
```

More negative = higher jumps

### Change Gravity

Edit `scripts/player.gd`:

```gdscript
@export var gravity = 600.0  # Default: 980.0
```

Lower values = floatier physics

### Change Background Color

Edit level in `levels_config.json`:

```json
{
  "background_color": "#FF0000"  # Hex color
}
```

Or directly in scene file's ColorRect node.

## Physics Customization

### Floaty Jump Feel

For more air time and control:

```gdscript
# In player.gd
@export var gravity = 600.0  # Reduced from 980
@export var jump_velocity = -700.0  # Keep same or adjust
```

**Result**: Slower fall, more time to adjust mid-air

### Fast-Paced Action

For quick, snappy movement:

```gdscript
@export var speed = 500.0  # Increased from 300
@export var gravity = 1200.0  # Increased from 980
@export var jump_velocity = -800.0  # Stronger jump
```

**Result**: Fast movement, quick fall, responsive controls

### Tight Controls

For precise platforming:

```gdscript
# In _physics_process()
# Change friction (how quickly player stops)
velocity.x = move_toward(velocity.x, 0, speed * 2)  # Default: speed * 1
```

**Result**: Player stops faster when no input

### Slippery Movement

For ice-like physics:

```gdscript
# In _physics_process()
velocity.x = move_toward(velocity.x, 0, speed * 0.3)  # Reduced friction
```

**Result**: Player slides when stopping

## Advanced Physics Features

### Double Jump

Add to `player.gd`:

```gdscript
var jumps_remaining = 2
var max_jumps = 2

func _physics_process(delta):
    # Apply gravity
    if not is_on_floor():
        velocity.y += gravity * delta
    else:
        # Reset jumps when landing
        jumps_remaining = max_jumps
    
    # Handle jump with double jump
    if Input.is_action_just_pressed("ui_accept") and jumps_remaining > 0:
        velocity.y = jump_velocity
        jumps_remaining -= 1
    
    # ... rest of code
```

### Variable Jump Height

Hold jump button for higher jumps:

```gdscript
func _physics_process(delta):
    # ... existing code
    
    # Cut jump short when button released
    if Input.is_action_just_released("ui_accept") and velocity.y < 0:
        velocity.y *= 0.5  # Reduce upward velocity
    
    # ... rest of code
```

### Wall Jump

Add wall detection and jumping:

```gdscript
func _physics_process(delta):
    # ... existing code
    
    # Wall jump
    if is_on_wall() and Input.is_action_just_pressed("ui_accept"):
        velocity.y = jump_velocity
        # Push away from wall
        velocity.x = -get_wall_normal().x * speed
    
    # ... rest of code
```

### Dash Ability

Add quick dash movement:

```gdscript
var can_dash = true
var dash_speed = 800.0
var dash_duration = 0.2
var dash_timer = 0.0

func _physics_process(delta):
    # ... existing gravity and jump code
    
    # Dash logic
    if Input.is_action_just_pressed("ui_shift") and can_dash:
        dash_timer = dash_duration
        can_dash = false
        # Start dash cooldown
        get_tree().create_timer(1.0).timeout.connect(func(): can_dash = true)
    
    # Apply dash
    if dash_timer > 0:
        dash_timer -= delta
        var direction = Input.get_axis("ui_left", "ui_right")
        if direction != 0:
            velocity.x = direction * dash_speed
    else:
        # Normal movement
        var direction = Input.get_axis("ui_left", "ui_right")
        if direction:
            velocity.x = direction * speed
        else:
            velocity.x = move_toward(velocity.x, 0, speed)
    
    move_and_slide()
```

## Platform Customization

### Platform Colors

Edit `scenes/platform.tscn` ColorRect:

```
[node name="ColorRect" type="ColorRect" parent="."]
color = Color(0.4, 0.6, 0.3, 1)  # RGB values (0-1), Alpha
```

**Examples**:
- Green grass: `(0.4, 0.6, 0.3, 1)`
- Stone gray: `(0.5, 0.5, 0.5, 1)`
- Ice blue: `(0.7, 0.8, 1.0, 1)`

### Platform Sizes

Edit `hooks/post_gen_project.py`:

```python
def generate_platform_layout(collectible_count, layout='horizontal'):
    platforms = []
    
    # Ground platform
    platforms.append({
        'x': 0,
        'y': 600,
        'width': 3000,  # Change width
        'height': 48,   # Change height
        'type': 'ground'
    })
    
    # Jump platforms
    for i in range(num_platforms):
        platforms.append({
            'x': x_position,
            'y': y_position,
            'width': 250,  # Change from default 200
            'height': 50,  # Change from default 40
            'type': 'platform'
        })
```

### Moving Platforms

Replace StaticBody2D with AnimatableBody2D:

1. Open `scenes/platform.tscn`
2. Change node type from StaticBody2D to AnimatableBody2D
3. Add AnimationPlayer node
4. Create position animation:

```gdscript
# In platform.gd (create this file)
extends AnimatableBody2D

var start_pos: Vector2
var move_distance = 200.0
var move_speed = 2.0

func _ready():
    start_pos = position

func _process(delta):
    position.x = start_pos.x + sin(Time.get_ticks_msec() / 1000.0 * move_speed) * move_distance
```

## Collectible Customization

### Collectible Size

Edit `scenes/collectible.tscn`:

```
[sub_resource type="RectangleShape2D" id="RectangleShape2D_1"]
size = Vector2(50, 50)  # Change from default 32x32
```

And ColorRect:
```
[node name="ColorRect" type="ColorRect" parent="."]
offset_left = -25.0  # Half of size
offset_top = -25.0
offset_right = 25.0
offset_bottom = 25.0
```

### Collectible Value

Edit `scripts/collectible.gd`:

```gdscript
func _on_body_entered(body):
    if body.name == "Player":
        var main_scene = get_tree().current_scene
        if main_scene.has_method("add_score"):
            main_scene.add_score(20)  # Change from default 10
        
        call_deferred("queue_free")
```

### Different Collectible Types

Create multiple collectible scenes with different values:

**collectible_gold.tscn** (30 points):
```gdscript
# In collectible_gold.gd
func _on_body_entered(body):
    if body.name == "Player":
        var main_scene = get_tree().current_scene
        if main_scene.has_method("add_score"):
            main_scene.add_score(30)
        call_deferred("queue_free")
```

**collectible_silver.tscn** (10 points):
```gdscript
# In collectible_silver.gd
func _on_body_entered(body):
    if body.name == "Player":
        var main_scene = get_tree().current_scene
        if main_scene.has_method("add_score"):
            main_scene.add_score(10)
        call_deferred("queue_free")
```

## UI Customization

### UI Position

Edit `scenes/ui_layer.tscn`:

```
[node name="ScoreLabel" type="Label" parent="."]
offset_left = 20.0  # Change X position
offset_top = 20.0   # Change Y position
```

### UI Font Size

```
[node name="ScoreLabel" type="Label" parent="."]
theme_override_font_sizes/font_size = 32  # Change size
```

### UI Colors

```
[node name="ScoreLabel" type="Label" parent="."]
theme_override_colors/font_color = Color(1, 1, 0, 1)  # Yellow text
```

## Camera Customization

### Camera Smoothing

Edit player scene camera settings in `scenes/player.tscn`:

```
[node name="Camera2D" type="Camera2D" parent="."]
position_smoothing_enabled = true
position_smoothing_speed = 8.0  # Change from default 5.0
```

Higher = faster following, lower = smoother/laggier

### Camera Limits

Adjust for different level widths:

```
[node name="Camera2D" type="Camera2D" parent="."]
limit_left = 0
limit_right = 5000  # Change from default 3000
limit_top = 0
limit_bottom = 648
```

### Camera Zoom

```
[node name="Camera2D" type="Camera2D" parent="."]
zoom = Vector2(1.5, 1.5)  # Zoom in (default is 1,1)
zoom = Vector2(0.8, 0.8)  # Zoom out
```

### Camera Shake

Add to `player.gd` or create camera script:

```gdscript
# In camera script
extends Camera2D

var shake_amount = 0.0
var shake_duration = 0.0

func _process(delta):
    if shake_duration > 0:
        shake_duration -= delta
        offset = Vector2(
            randf_range(-shake_amount, shake_amount),
            randf_range(-shake_amount, shake_amount)
        )
    else:
        offset = Vector2.ZERO

func shake(amount: float, duration: float):
    shake_amount = amount
    shake_duration = duration
```

Trigger on events:
```gdscript
# When player takes damage or collects item
camera.shake(10.0, 0.2)
```

## Animation Customization

### Animation Speed

Edit `scenes/player.tscn` SpriteFrames:

```
"name": &"walk",
"speed": 15.0  # Change from default 10.0
```

Or in code:
```gdscript
animated_sprite.speed_scale = 1.5  # 50% faster
```

### Custom Animations

See [Animation System](animations.md) for detailed guide.

**Quick example - Add hurt animation:**

1. Add "hurt" animation to SpriteFrames
2. In player.gd:

```gdscript
func take_damage():
    if animated_sprite:
        animated_sprite.play("hurt")
        await animated_sprite.animation_finished
        animated_sprite.play("idle")
```

## Audio Customization

### Victory Sound

Specify custom sound in config:

```json
{
  "victory_sound": "./my_sounds/fanfare.wav"
}
```

### Jump Sound Effect

Add to `player.gd`:

```gdscript
@onready var jump_sound = $JumpSound  # Add AudioStreamPlayer2D node

func _physics_process(delta):
    # ... existing code
    
    if Input.is_action_just_pressed("ui_accept") and is_on_floor():
        velocity.y = jump_velocity
        jump_sound.play()  # Play sound
    
    # ... rest of code
```

### Collection Sound

Add to `collectible.gd`:

```gdscript
@onready var collect_sound = $CollectSound

func _on_body_entered(body):
    if body.name == "Player":
        collect_sound.play()
        # Hide visual but keep node alive for sound
        $ColorRect.visible = false
        $CollisionShape2D.disabled = true
        # Remove after sound finishes
        await collect_sound.finished
        queue_free()
```

## Game Mode Customization

### Lives System

Add to `game_manager.gd`:

```gdscript
var lives = 3
var max_lives = 3

func take_damage():
    lives -= 1
    update_ui()
    if lives <= 0:
        game_over()

func update_ui():
    # Add lives label to UI
    var lives_label = ui_layer.get_node_or_null("LivesLabel")
    if lives_label:
        lives_label.text = "Lives: " + str(lives)
```

### Combo System

Track consecutive collections:

```gdscript
# In game_manager.gd
var combo = 0
var combo_timer = 0.0
var combo_timeout = 2.0

func add_score(points):
    combo += 1
    combo_timer = combo_timeout
    var bonus = points * combo
    score += bonus
    update_ui()

func _process(delta):
    if combo_timer > 0:
        combo_timer -= delta
    else:
        combo = 0
```

### Difficulty Progression

Auto-adjust difficulty:

```gdscript
# In level_manager.gd or game_manager.gd
func increase_difficulty():
    # Adjust physics
    var player = get_tree().get_first_node_in_group("player")
    if player:
        player.speed *= 0.9  # 10% slower each level
        player.gravity *= 1.1  # 10% more gravity
```

## Visual Customization

### Particle Effects

Add collectible particle effect:

1. Add GPUParticles2D node to collectible scene
2. Configure in Inspector:

```gdscript
# In collectible.gd
@onready var particles = $GPUParticles2D

func _on_body_entered(body):
    if body.name == "Player":
        particles.emitting = true
        # ... rest of code
```

### Trail Effect

Add to player for motion trail:

1. Add Line2D node to player
2. Script:

```gdscript
@onready var trail = $Line2D
var trail_points = []
var max_trail_length = 20

func _process(delta):
    trail_points.append(global_position)
    if trail_points.size() > max_trail_length:
        trail_points.pop_front()
    
    trail.points = trail_points
```

### Screen Transitions

Add fade between levels:

```gdscript
# In level_manager.gd
func load_next_level():
    var fade = ColorRect.new()
    fade.color = Color.BLACK
    fade.color.a = 0
    add_child(fade)
    
    # Fade out
    var tween = create_tween()
    tween.tween_property(fade, "color:a", 1.0, 0.5)
    await tween.finished
    
    # Load level
    _load_level_scene(current_level)
    
    # Fade in
    tween = create_tween()
    tween.tween_property(fade, "color:a", 0.0, 0.5)
    await tween.finished
    fade.queue_free()
```

## Level Design

### Custom Platform Layouts

Edit `hooks/post_gen_project.py`:

```python
def generate_custom_platform_layout():
    platforms = []
    
    # Create staircase pattern
    for i in range(10):
        platforms.append({
            'x': i * 300,
            'y': 600 - (i * 50),
            'width': 200,
            'height': 40,
            'type': 'platform'
        })
    
    return platforms
```

### Hazards

Create hazard scene (spikes, pits):

```gdscript
# hazard.gd
extends Area2D

func _on_body_entered(body):
    if body.name == "Player":
        # Respawn player or reduce lives
        get_tree().reload_current_scene()
```

### Checkpoints

Add checkpoint system:

```gdscript
# checkpoint.gd
extends Area2D

func _on_body_entered(body):
    if body.name == "Player":
        var game_manager = get_tree().current_scene
        game_manager.set_checkpoint(global_position)
```

## Performance Optimization

### Reduce Draw Calls

Use TextureRect instead of multiple ColorRects:

```gdscript
# Create sprite sheet with all graphics
# Use AtlasTexture for sub-regions
```

### Limit Active Objects

Pool collectibles instead of creating/destroying:

```gdscript
var collectible_pool = []

func get_collectible():
    if collectible_pool.is_empty():
        return collectible_scene.instantiate()
    else:
        return collectible_pool.pop_back()

func return_collectible(collectible):
    collectible_pool.append(collectible)
```

## Next Steps

- [Platformer Features](platformer.md) - Understand physics system
- [Animation System](animations.md) - Customize animations
- [Level Configuration](levels.md) - Design custom levels
- [Project Structure](structure.md) - Navigate the codebase

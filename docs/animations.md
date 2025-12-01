# Animation System

Complete guide to the sprite animation system for player characters and NPCs.

## Overview

The template uses Godot's `AnimatedSprite2D` node with `SpriteFrames` resources to create smooth sprite animations. Both player characters and NPCs have multiple animations that automatically switch based on game state.

## Player Animations

The player character has three animation states that change dynamically during gameplay.

### Animation States

#### Idle Animation

**When it plays**: Player is standing still (velocity ≈ 0)

**Properties**:
- **Animation Name**: `"idle"`
- **Speed**: 5.0 FPS
- **Looping**: Yes (continuous)
- **Frame Count**: 1 (default)

**Trigger Condition**:
```gdscript
if abs(velocity.x) <= 10:
    animated_sprite.play("idle")
```

#### Walk Animation

**When it plays**: Player is moving left or right

**Properties**:
- **Animation Name**: `"walk"`
- **Speed**: 10.0 FPS
- **Looping**: Yes (continuous)
- **Frame Count**: 1 (default)

**Trigger Condition**:
```gdscript
if abs(velocity.x) > 10:
    animated_sprite.play("walk")
```

**Special Behavior**:
- Sprite automatically flips horizontally based on movement direction
- `flip_h = true` when moving left
- `flip_h = false` when moving right

#### Collect Animation

**When it plays**: Player collects a collectible item

**Properties**:
- **Animation Name**: `"collect"`
- **Speed**: 15.0 FPS
- **Looping**: No (plays once)
- **Frame Count**: 1 (default)

**Trigger**:
```gdscript
# Called from collectible.gd when player touches item
func play_collect_animation():
    if animated_sprite:
        animated_sprite.play("collect")
```

**Priority**: Collection animation has highest priority and plays to completion before resuming idle/walk animations.

## NPC Animations

NPCs have two animation states that change when the player approaches.

### Animation States

#### Idle Animation

**When it plays**: No player nearby

**Properties**:
- **Animation Name**: `"idle"`
- **Speed**: 5.0 FPS
- **Looping**: Yes (continuous)
- **Frame Count**: 1 (default)

**Trigger Condition**:
```gdscript
func hide_speech_bubble():
    if animated_sprite:
        animated_sprite.play("idle")
```

#### Talking Animation

**When it plays**: Player is within NPC collision area

**Properties**:
- **Animation Name**: `"talking"`
- **Speed**: 8.0 FPS (slightly faster than idle)
- **Looping**: Yes (continuous)
- **Frame Count**: 1 (default)

**Trigger Condition**:
```gdscript
func show_speech_bubble():
    if animated_sprite:
        animated_sprite.play("talking")
```

**Visual Feedback**: Plays simultaneously with speech bubble appearance.

## Animation Implementation

### Player Animation Setup

**Scene**: `{{cookiecutter.project_slug}}/scenes/player.tscn`

**Node Structure**:
```
Player (CharacterBody2D)
└── AnimatedSprite2D
    └── sprite_frames (SpriteFrames resource)
        ├── Animation: "idle"
        ├── Animation: "walk"
        └── Animation: "collect"
```

**Script**: `{{cookiecutter.project_slug}}/scripts/player.gd`

**Key Functions**:

```gdscript
func _ready():
    # Load player type texture and apply to all animations
    _setup_animations_with_texture(texture)

func _setup_animations_with_texture(texture: Texture2D):
    # Apply texture to all three animation frames
    var sprite_frames = animated_sprite.sprite_frames
    for anim_name in ["idle", "walk", "collect"]:
        sprite_frames.set_frame_texture(anim_name, 0, texture)

func _update_animation():
    # Automatically switch animations based on state
    if abs(velocity.x) > 10:
        if animated_sprite.animation != "walk":
            animated_sprite.play("walk")
        # Flip sprite based on direction
        if velocity.x < 0:
            animated_sprite.flip_h = true
        elif velocity.x > 0:
            animated_sprite.flip_h = false
    else:
        if animated_sprite.animation != "idle":
            animated_sprite.play("idle")

func play_collect_animation():
    # Triggered externally by collectible
    if animated_sprite:
        animated_sprite.play("collect")
```

### NPC Animation Setup

**Scene**: `{{cookiecutter.project_slug}}/scenes/npc.tscn`

**Node Structure**:
```
NPC (Node2D)
├── AnimatedSprite2D
│   └── sprite_frames (SpriteFrames resource)
│       ├── Animation: "idle"
│       └── Animation: "talking"
├── Area2D (collision detection)
└── SpeechBubble (CanvasLayer)
```

**Script**: `{{cookiecutter.project_slug}}/scripts/npc.gd`

**Key Functions**:

```gdscript
func _on_body_entered(body):
    if body.name == "Player":
        show_speech_bubble()

func _on_body_exited(body):
    if body.name == "Player":
        hide_speech_bubble()

func show_speech_bubble():
    speech_bubble.visible = true
    if animated_sprite:
        animated_sprite.play("talking")

func hide_speech_bubble():
    speech_bubble.visible = false
    if animated_sprite:
        animated_sprite.play("idle")
```

### Level-Specific NPC Textures

In multi-level games, each level can have unique NPC sprites while using the same animation structure.

**How It Works**:

1. **Base Scene**: `npc.tscn` defines animation structure
2. **Level Override**: Each level scene creates custom `SpriteFrames` resource
3. **Texture Application**: Level-specific texture applied to both animations
4. **Automatic**: Handled by `hooks/post_gen_project.py`

**Example Level Scene Override**:
```
[sub_resource type="SpriteFrames" id="SpriteFrames_level1"]
animations = [{
    "name": &"idle",
    "frames": [{
        "texture": ExtResource("level_1_npc_texture")
    }]
}, {
    "name": &"talking",
    "frames": [{
        "texture": ExtResource("level_1_npc_texture")
    }]
}]

[node name="NPC" instance=ExtResource("npc_scene")]
AnimatedSprite2D.sprite_frames = SubResource("SpriteFrames_level1")
```

## Animation Frame Structure

### Default Single-Frame Animations

By default, all animations use a single texture frame:

```gdscript
SpriteFrames:
  - Animation "idle":
      - Frame 0: player_texture.svg
      - Speed: 5.0 FPS
      - Loop: true
  
  - Animation "walk":
      - Frame 0: player_texture.svg
      - Speed: 10.0 FPS
      - Loop: true
  
  - Animation "collect":
      - Frame 0: player_texture.svg
      - Speed: 15.0 FPS
      - Loop: false
```

### Why Single Frame?

Single-frame animations work well for:
- **Simple sprites**: SVG graphics that don't need motion
- **Placeholder graphics**: Before creating full animation sequences
- **Performance**: Minimal resource usage
- **Simplicity**: Easy to understand and modify

The animation system still provides visual feedback through:
- **Speed differences**: Faster "speeds" for more active states
- **Sprite flipping**: Left/right direction
- **Animation switching**: Visual state changes

## Customizing Animations

### Adding Multi-Frame Animations

To create actual animated sequences (e.g., walking cycle):

**Method 1: In Godot Editor**

1. Open scene in Godot (e.g., `scenes/player.tscn`)
2. Select `AnimatedSprite2D` node
3. In Inspector, click `SpriteFrames` resource
4. Opens SpriteFrames editor panel at bottom
5. Select animation (e.g., "walk")
6. Click "Add Frame" button (+ icon)
7. Choose texture files for each frame
8. Adjust speed slider to control animation speed
9. Preview with play button

**Method 2: In .tscn File**

Directly edit the scene file:

```
[sub_resource type="SpriteFrames" id="SpriteFrames_1"]
animations = [{
"name": &"walk",
"speed": 10.0,
"loop": true,
"frames": [{
"duration": 1.0,
"texture": ExtResource("walk_frame_1")
}, {
"duration": 1.0,
"texture": ExtResource("walk_frame_2")
}, {
"duration": 1.0,
"texture": ExtResource("walk_frame_3")
}, {
"duration": 1.0,
"texture": ExtResource("walk_frame_4")
}]
}]
```

### Changing Animation Speeds

**In Godot Editor**:
1. Select `AnimatedSprite2D` node
2. Open `SpriteFrames` editor
3. Select animation
4. Adjust "Speed (FPS)" slider

**In Code**:
```gdscript
animated_sprite.speed_scale = 1.5  # 1.5x speed
animated_sprite.speed_scale = 0.5  # Half speed
```

**In Scene File**:
```
"name": &"walk",
"speed": 15.0  # Change from 10.0 to 15.0 for faster animation
```

### Adding New Animations

**Example: Jump Animation**

1. **Add Animation to SpriteFrames**:
   - Open scene in Godot
   - Edit `SpriteFrames` resource
   - Click "New Anim" button
   - Name it "jump"
   - Add jump texture frame(s)

2. **Trigger in Script**:

```gdscript
func _physics_process(delta):
    # Apply gravity
    if not is_on_floor():
        velocity.y += gravity * delta
        
        # Play jump animation while airborne
        if animated_sprite.animation != "jump":
            animated_sprite.play("jump")
    
    # Handle jump input
    if Input.is_action_just_pressed("ui_accept") and is_on_floor():
        velocity.y = jump_velocity
        animated_sprite.play("jump")
    
    # ... rest of movement code
```

3. **Update Animation Logic**:

```gdscript
func _update_animation():
    # Don't override jump animation while in air
    if not is_on_floor():
        return
    
    # Ground animations
    if abs(velocity.x) > 10:
        if animated_sprite.animation != "walk":
            animated_sprite.play("walk")
        # Flip sprite
        if velocity.x < 0:
            animated_sprite.flip_h = true
        elif velocity.x > 0:
            animated_sprite.flip_h = false
    else:
        if animated_sprite.animation != "idle":
            animated_sprite.play("idle")
```

## Animation Best Practices

### Frame Rates

- **Idle**: 5-8 FPS (slow, subtle motion)
- **Walk/Run**: 10-15 FPS (smooth motion)
- **Fast Actions**: 15-20 FPS (quick feedback)
- **Effects**: 20-30 FPS (rapid visual feedback)

### Looping

- **Idle, Walk, Run**: Loop = true (continuous)
- **Jump, Attack, Collect**: Loop = false (one-shot)
- **Effects**: Loop = false unless repeating effect

### Animation Priority

Establish clear priorities:

1. **Highest**: Death, Hit, Special Moves
2. **Medium**: Jump, Attack, Collect
3. **Lowest**: Idle, Walk

**Implementation**:
```gdscript
var current_priority = 0

func play_animation(anim_name: String, priority: int):
    if priority >= current_priority:
        animated_sprite.play(anim_name)
        current_priority = priority

func _on_animation_finished():
    current_priority = 0  # Reset after one-shot animations
```

### Sprite Sheet Support

For multi-frame animations from sprite sheets:

1. Import sprite sheet as texture
2. In Import settings, set "Frames" horizontal/vertical
3. Godot auto-splits into frames
4. Use split textures in `SpriteFrames`

## Technical Details

### Resource Management

**Player Animations**:
- Textures loaded dynamically based on player type
- Single `SpriteFrames` resource per player scene
- Texture applied at runtime in `_ready()`

**NPC Animations**:
- Base `SpriteFrames` in `npc.tscn`
- Overridden per level via scene inheritance
- Custom `SpriteFrames` sub-resource in level scenes

### Performance

**Single-Frame Animations**:
- Minimal memory usage
- No texture switching overhead
- Ideal for simple graphics

**Multi-Frame Animations**:
- More memory per animation
- Texture switching every frame
- Use texture atlases for optimization

### File Locations

```
{{cookiecutter.project_slug}}/
├── scenes/
│   ├── player.tscn          # Player AnimatedSprite2D setup
│   ├── npc.tscn             # Base NPC AnimatedSprite2D
│   ├── level_1.tscn         # Overrides NPC SpriteFrames
│   └── level_2.tscn         # Overrides NPC SpriteFrames
├── scripts/
│   ├── player.gd            # Player animation logic
│   └── npc.gd               # NPC animation logic
└── assets/
    ├── player_blue.svg      # Player textures
    ├── player_red.svg
    ├── level_1_npc.svg      # NPC textures per level
    └── level_2_npc.svg
```

## Troubleshooting

### Animation Not Playing

**Check**:
- `AnimatedSprite2D` node exists
- `SpriteFrames` resource is assigned
- Animation name is spelled correctly
- Animation has at least one frame

**Debug**:
```gdscript
print("Current animation: ", animated_sprite.animation)
print("Is playing: ", animated_sprite.is_playing())
```

### Sprite Not Visible

**Check**:
- Texture is loaded
- Sprite scale > 0
- Sprite not behind other nodes
- Camera can see sprite position

**Debug**:
```gdscript
print("Sprite visible: ", animated_sprite.visible)
print("Sprite position: ", animated_sprite.position)
print("Frame count: ", animated_sprite.sprite_frames.get_frame_count("idle"))
```

### Animation Stuck

**Check**:
- Animation has `loop = true` if meant to repeat
- No conflicting `play()` calls
- Animation speed > 0

**Fix**:
```gdscript
# Force restart animation
animated_sprite.stop()
animated_sprite.play("idle")
```

### Wrong Texture Displayed

**Check**:
- Texture path is correct
- Texture file exists
- Resource loaded successfully

**Debug**:
```gdscript
var texture = animated_sprite.sprite_frames.get_frame_texture("idle", 0)
print("Texture loaded: ", texture != null)
```

## Next Steps

- [Customization Guide](customization.md) - Modify animation behavior
- [Platformer Features](platformer.md) - Understand physics integration
- [Project Structure](structure.md) - Find animation files

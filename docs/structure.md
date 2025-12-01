# Project Structure

Complete guide to the generated project's file structure and organization.

## Directory Layout

```
your_project/
├── project.godot              # Godot project configuration
├── icon.svg                   # Project icon (shown in Godot project manager)
├── levels_config.json         # Level definitions (if level_count > 1)
├── .gutconfig.json            # GUT testing configuration
├── scenes/                    # All scene files (.tscn)
│   ├── player.tscn           # Player character scene
│   ├── platform.tscn         # Platform scene (StaticBody2D)
│   ├── collectible.tscn      # Collectible item scene
│   ├── npc.tscn              # NPC scene (if include_npc=yes)
│   ├── player_select.tscn    # Player selection menu
│   ├── ui_layer.tscn         # Score and UI overlay
│   ├── main.tscn             # Main game scene (single-level mode)
│   ├── level_1.tscn          # Level 1 scene (multi-level mode)
│   ├── level_2.tscn          # Level 2 scene (multi-level mode)
│   └── ...                   # Additional levels
├── scripts/                   # All GDScript files (.gd)
│   ├── player.gd             # Player movement and physics
│   ├── collectible.gd        # Collectible behavior
│   ├── npc.gd                # NPC interaction (if include_npc=yes)
│   ├── player_select.gd      # Player selection logic
│   ├── ui_layer.gd           # UI management
│   ├── level_manager.gd      # Level transitions (if level_count > 1)
│   └── game_manager.gd       # Score, game state, game mode
├── assets/                    # Game assets
│   ├── player_blue.svg       # Player sprites (one per player type)
│   ├── player_red.svg
│   ├── player_green.svg
│   ├── npc.svg               # Default NPC sprite
│   ├── level_1_npc.svg       # Level-specific NPC sprites
│   ├── level_2_npc.svg
│   ├── ...
│   └── victory.wav           # Victory sound effect
├── tests/                     # Unit tests (GUT framework)
│   ├── test_player.gd
│   ├── test_collectible.gd
│   ├── test_npc.gd
│   └── test_game_manager.gd
└── addons/                    # Godot addons
    └── gut/                  # GUT testing framework (if installed)
```

## Core Files

### project.godot

**Purpose**: Godot project configuration file

**Contains**:
- Project settings (display size, name, version)
- Input mappings (ui_left, ui_right, ui_accept, etc.)
- Physics configuration
- Autoload singletons
- Rendering settings

**Key Settings**:
```ini
[application]
config/name = "Your Project Name"
run/main_scene = "res://scenes/player_select.tscn"
config/features = PackedStringArray("4.5")

[display]
window/size/viewport_width = 1152
window/size/viewport_height = 648

[input]
ui_left = ...
ui_right = ...
ui_accept = ...
```

**When to Edit**: Rarely. Most settings configured via Godot Editor.

### levels_config.json

**Purpose**: Level definitions for multi-level games

**Generated When**: `level_count > 1`

**Format**:
```json
{
  "levels": [
    {
      "name": "level_1",
      "collectibles": 4,
      "target_score": 40,
      "background_color": "#1a1a1a",
      "layout": "grid",
      "npc": {
        "enabled": true,
        "message": "Welcome!",
        "svg": ""
      }
    }
  ]
}
```

**See**: [Level Configuration](levels.md) for details

### .gutconfig.json

**Purpose**: GUT test framework configuration

**Format**:
```json
{
  "dirs": ["res://tests/"],
  "include_subdirs": true,
  "log_level": 1,
  "should_exit": true,
  "should_maximize": false
}
```

**See**: [Testing Guide](testing.md) for details

## Scene Files

### player.tscn

**Type**: CharacterBody2D

**Purpose**: Player character with platformer physics

**Node Structure**:
```
Player (CharacterBody2D)
├── CollisionShape2D (capsule collision)
├── AnimatedSprite2D (sprite animations)
│   └── SpriteFrames (idle, walk, collect animations)
└── Camera2D (following camera)
```

**Script**: `scripts/player.gd`

**Key Features**:
- Gravity and jumping
- Horizontal movement
- Sprite flipping
- Animation system
- Camera following

**Collision**:
- Layer: 2
- Mask: 1 (detects platforms)

### platform.tscn

**Type**: StaticBody2D

**Purpose**: Solid platforms for jumping

**Node Structure**:
```
Platform (StaticBody2D)
├── CollisionShape2D (rectangle shape)
└── ColorRect (visual representation)
```

**Script**: None (static)

**Customizable**:
- Size (width, height)
- Color
- Position (set in level scenes)

**Collision**:
- Layer: 1
- Mask: 0 (doesn't check collisions)

### collectible.tscn

**Type**: Area2D

**Purpose**: Items to collect for score

**Node Structure**:
```
Collectible (Area2D)
├── CollisionShape2D (circle or rectangle)
└── ColorRect (visual representation)
```

**Script**: `scripts/collectible.gd`

**Behavior**:
- Detects player collision
- Triggers score increase
- Plays collect animation on player
- Removes self from scene

**Collision**:
- Layer: 8 (layer 4)
- Mask: 2 (detects player)

### npc.tscn

**Type**: Node2D

**Purpose**: Non-player character with speech bubble

**Node Structure**:
```
NPC (Node2D)
├── AnimatedSprite2D (NPC sprite)
│   └── SpriteFrames (idle, talking animations)
├── Area2D (interaction trigger)
│   └── CollisionShape2D (detection area)
└── SpeechBubble (CanvasLayer)
    ├── Panel (bubble background)
    └── Label (message text)
```

**Script**: `scripts/npc.gd`

**Behavior**:
- Detects player proximity
- Shows/hides speech bubble
- Switches between idle and talking animations

**Collision**:
- Layer: 4
- Mask: 2 (detects player)

### player_select.tscn

**Type**: Control

**Purpose**: Player type selection menu

**Node Structure**:
```
PlayerSelect (Control)
├── ColorRect (background)
├── VBoxContainer (layout)
│   ├── Label (title)
│   ├── HBoxContainer (options)
│   │   ├── Button (player type 1)
│   │   ├── Button (player type 2)
│   │   └── ...
│   └── Button (start game)
└── ...
```

**Script**: `scripts/player_select.gd`

**Behavior**:
- Displays available player types
- Handles selection
- Starts game with selected type
- Persists selection across levels

### ui_layer.tscn

**Type**: CanvasLayer

**Purpose**: On-screen UI for score and game info

**Node Structure**:
```
UILayer (CanvasLayer)
├── ScoreLabel (Label)
├── TargetLabel (Label)
├── TimerLabel (Label)
└── GameOverLabel (Label)
```

**Script**: `scripts/ui_layer.gd`

**Features**:
- Score display
- Target score display
- Timer (timed mode)
- Game over messages

### main.tscn

**Type**: Node2D

**Purpose**: Main game scene (single-level games)

**Generated When**: `level_count == 1`

**Node Structure**:
```
Main (Node2D)
├── Camera2D (fallback camera)
├── ColorRect (background)
├── Player (instance of player.tscn)
├── Platform (ground)
├── Platform (jump platforms)
├── ...
├── Collectible (instances)
├── ...
├── NPC (instance of npc.tscn)
└── UILayer (instance of ui_layer.tscn)
```

**Script**: `scripts/game_manager.gd`

### level_N.tscn

**Type**: Node2D

**Purpose**: Individual level scenes (multi-level games)

**Generated When**: `level_count > 1`

**Node Structure**: Similar to main.tscn

**Differences**:
- Custom background color per level
- Different platform layouts
- Varying collectible counts
- Level-specific NPCs

**Script**: `scripts/game_manager.gd`

## Script Files

### player.gd

**Attached To**: `player.tscn`

**Purpose**: Player movement and physics

**Key Variables**:
```gdscript
@export var speed = 300.0
@export var jump_velocity = -700.0
@export var gravity = 980.0
var player_type: String = ""
```

**Key Functions**:
```gdscript
func _ready()  # Initialize sprite and animations
func _physics_process(delta)  # Physics and movement
func _update_animation()  # Switch animations
func play_collect_animation()  # Play collect animation
```

**See**: [Platformer Features](platformer.md)

### collectible.gd

**Attached To**: `collectible.tscn`

**Purpose**: Collectible behavior

**Key Functions**:
```gdscript
func _on_body_entered(body)  # Detect player, add score, remove self
```

**Points Awarded**: 10 (default, customizable)

### npc.gd

**Attached To**: `npc.tscn`

**Purpose**: NPC interaction

**Key Variables**:
```gdscript
@export var message = "Hello!"
```

**Key Functions**:
```gdscript
func _on_body_entered(body)  # Show speech bubble
func _on_body_exited(body)  # Hide speech bubble
func show_speech_bubble()  # Display and play talking animation
func hide_speech_bubble()  # Hide and play idle animation
```

### player_select.gd

**Attached To**: `player_select.tscn`

**Purpose**: Player selection menu logic

**Key Variables**:
```gdscript
var selected_player_type = "blue"
var player_types = ["blue", "red", "green"]
```

**Key Functions**:
```gdscript
func _ready()  # Setup buttons
func _on_player_button_pressed(type)  # Handle selection
func _on_start_button_pressed()  # Start game
```

### ui_layer.gd

**Attached To**: `ui_layer.tscn`

**Purpose**: UI management

**Key Functions**:
```gdscript
func update_score(score)  # Update score label
func update_target(target)  # Update target label
func update_timer(time)  # Update timer label
func show_game_over(message)  # Display game over
```

### game_manager.gd

**Attached To**: `main.tscn` or level scenes

**Purpose**: Game state, scoring, game mode logic

**Key Variables**:
```gdscript
var score = 0
var target_score = 100
var game_mode = "endless"
var time_limit = 60
var time_remaining = 60
var game_over = false
```

**Key Functions**:
```gdscript
func _ready()  # Initialize game
func _process(delta)  # Update timer, check win/lose
func add_score(points)  # Increase score
func check_victory()  # Check if won
func game_over()  # Handle game over
func update_ui()  # Update UI elements
func _input(event)  # Handle restart input
```

### level_manager.gd

**Attached To**: None (singleton or main scene)

**Purpose**: Level progression (multi-level games)

**Generated When**: `level_count > 1`

**Key Variables**:
```gdscript
var current_level = 1
var total_levels = 3
var selected_player_type = ""
```

**Key Functions**:
```gdscript
func load_next_level()  # Load next level
func _load_level_scene(level_num)  # Load specific level
func set_player_type(type)  # Store player selection
```

## Asset Files

### Player Sprites

**Files**: `player_blue.svg`, `player_red.svg`, etc.

**Format**: SVG (Scalable Vector Graphics)

**Usage**:
- Loaded dynamically by `player.gd`
- Applied to all animation frames
- One file per player type

**Customization**: Replace with custom SVGs via `custom_player_svgs` parameter

### NPC Sprites

**Files**: 
- `npc.svg` (default, single-level)
- `level_1_npc.svg`, `level_2_npc.svg` (multi-level)

**Format**: SVG

**Usage**:
- Referenced in level scenes
- Applied to NPC AnimatedSprite2D
- Can be different per level

**Customization**: Specify in `levels_config.json`

### Victory Sound

**File**: `victory.wav`

**Format**: WAV or OGG

**Usage**:
- Played when reaching target score
- Loaded by `game_manager.gd`

**Customization**: Replace via `victory_sound` parameter

## Test Files

### test_player.gd

**Purpose**: Unit tests for player

**Tests**:
- Speed, jump velocity, gravity values
- AnimatedSprite2D existence
- CharacterBody2D type

### test_collectible.gd

**Purpose**: Unit tests for collectible

**Tests**:
- Area2D type
- Collision shape existence
- Visual element existence

### test_npc.gd

**Purpose**: Unit tests for NPC

**Tests**:
- Speech bubble functionality
- Animation switching
- Message display

### test_game_manager.gd

**Purpose**: Unit tests for game logic

**Tests**:
- Score tracking
- Victory conditions
- Game mode behavior

**See**: [Testing Guide](testing.md)

## File Naming Conventions

### Scenes

- **Pattern**: `lowercase_with_underscores.tscn`
- **Examples**: `player.tscn`, `level_1.tscn`, `player_select.tscn`

### Scripts

- **Pattern**: `lowercase_with_underscores.gd`
- **Match Scene**: Script name matches scene name
- **Examples**: `player.gd`, `level_manager.gd`

### Assets

- **Pattern**: `descriptive_name.extension`
- **Examples**: `player_blue.svg`, `victory.wav`, `level_1_npc.svg`

### Tests

- **Pattern**: `test_<feature>.gd`
- **Examples**: `test_player.gd`, `test_game_manager.gd`

## Navigation Tips

### Finding Features

- **Player Physics**: `scripts/player.gd`
- **Scoring Logic**: `scripts/game_manager.gd`
- **Level Data**: `levels_config.json`
- **UI Elements**: `scenes/ui_layer.tscn`
- **Collectible Placement**: `hooks/post_gen_project.py` (in template)

### Common Modifications

- **Adjust Physics**: Edit `scripts/player.gd` exports
- **Change Colors**: Edit ColorRect nodes in scenes
- **Add Levels**: Modify `levels_config.json`
- **Custom Sounds**: Replace files in `assets/`
- **New Mechanics**: Add to relevant script files

## Dependencies

### External

- **Godot 4.0+**: Game engine
- **GUT** (optional): Testing framework

### Internal

- **player.tscn** → `player.gd`
- **main.tscn** / level scenes → `game_manager.gd`
- **collectible.tscn** → `collectible.gd`
- **npc.tscn** → `npc.gd`
- Level scenes → `levels_config.json` (data source)

## Next Steps

- [Customization Guide](customization.md) - Modify project files
- [Testing Guide](testing.md) - Understand test structure
- [Quick Start](quick-start.md) - Generate your first project

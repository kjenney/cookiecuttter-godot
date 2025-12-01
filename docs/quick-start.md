# Quick Start

Get up and running with your first platformer game in minutes!

## Usage Options

There are three ways to use this template, depending on your needs.

### Option 1: Interactive Mode (Easiest)

Create a new project and answer prompts for each configuration option:

```bash
cookiecutter .
```

You will be prompted for all configuration values:

- `project_name`: Display name (e.g., "My Awesome Game")
- `player_types`: Character types (e.g., "warrior,mage,rogue")
- `game_mode`: endless, timed, or score_target
- `level_count`: Number of levels
- And more...

**Best for**: First-time users, simple projects

### Option 2: Command-Line Arguments

Pass values directly without prompts:

```bash
cookiecutter . project_name="My Game" player_types="warrior,mage" \
  custom_player_svgs="warrior:/path/to/warrior.svg,mage:/path/to/mage.svg"
```

**Best for**: Quick generation with a few custom parameters

### Option 3: Config File (Recommended)

Use a JSON config file for complex setups:

```bash
cookiecutter . --no-input --config-file my_config.json
```

**Best for**: Complex projects, multiple levels, custom assets

## 5-Minute Game

Create your first game in 5 minutes:

### Step 1: Generate Project

```bash
cookiecutter . project_name="My Platformer" \
  project_slug="my_platformer" \
  level_count="3"
```

### Step 2: Open in Godot

```bash
cd my_platformer
godot project.godot
```

### Step 3: Run

Press **F5** or click the **Play** button in Godot.

### Step 4: Play!

- Select a character type
- Use **Arrow Keys** or **A/D** to move
- Press **SPACE** to jump
- Collect items to increase score

That's it! You've created a playable platformer game.

## Configuration File Example

For more control, create a config file:

**my_config.json**:
```json
{
  "default_context": {
    "project_name": "My Adventure Game",
    "project_slug": "my_adventure_game",
    "player_types": "warrior,mage,rogue",
    "game_mode": "timed",
    "time_limit": "60",
    "level_count": "3",
    "levels_config": "./my_levels.json"
  }
}
```

**my_levels.json**:
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
        "message": "Welcome! Collect 40 points!",
        "svg": ""
      }
    },
    {
      "name": "level_2",
      "collectibles": 6,
      "target_score": 60,
      "background_color": "#2a1a2a",
      "layout": "horizontal",
      "npc": {
        "enabled": true,
        "message": "Level 2 - Get 60 points!",
        "svg": ""
      }
    }
  ]
}
```

Then generate:

```bash
cookiecutter . --no-input --config-file my_config.json
```

## What Gets Generated

After running cookiecutter, you'll have:

```
my_platformer/
├── project.godot          # Godot project file
├── scenes/                # Game scenes
│   ├── player.tscn
│   ├── platform.tscn
│   ├── collectible.tscn
│   ├── npc.tscn
│   ├── level_1.tscn
│   └── ...
├── scripts/               # GDScript files
│   ├── player.gd
│   ├── game_manager.gd
│   ├── level_manager.gd
│   └── ...
├── assets/                # Graphics and sounds
│   ├── player_*.svg
│   ├── victory.wav
│   └── ...
└── levels_config.json     # Level definitions
```

## Opening the Project

### From Command Line

```bash
cd my_platformer
godot project.godot
```

### From Godot Editor

1. Open Godot Editor
2. Click "Import"
3. Navigate to `my_platformer/project.godot`
4. Click "Import & Edit"

## First Playthrough

1. **Player Selection**: Choose your character type
2. **Movement**: Use Arrow Keys or WASD (Left/Right)
3. **Jump**: Press SPACE, W, or UP arrow
4. **Collect Items**: Jump to platforms and collect golden objects
5. **Score**: Reach the target score to advance
6. **NPCs**: Walk near NPCs to see speech bubbles

## Customization Quick Tips

### Change Player Speed

Edit `scripts/player.gd`:

```gdscript
@export var speed = 400.0  # Increase for faster movement
```

### Change Jump Height

Edit `scripts/player.gd`:

```gdscript
@export var jump_velocity = -800.0  # More negative = higher jump
```

### Change Level Colors

Edit `levels_config.json`:

```json
{
  "background_color": "#FF0000"  # Red background
}
```

## Common First Steps

After generating your first game:

1. **Test the default game** - Play through to understand the mechanics
2. **Modify one level** - Change colors, collectible count, or messages
3. **Add custom graphics** - Replace default squares with your SVG art
4. **Adjust physics** - Tune gravity and jump to your preference
5. **Add more levels** - Increase difficulty progressively

## Next Steps

- [Configuration Guide](configuration.md) - Learn all configuration options
- [Level Configuration](levels.md) - Create custom level layouts
- [Controls](controls.md) - Understand player controls
- [Examples](examples.md) - See more configuration examples

## Troubleshooting

### Project won't open in Godot

- Ensure you're using Godot 4.0+
- Check that `project.godot` exists in the project directory
- Try "Scan" in Godot's project manager

### No player graphics visible

- Default colored squares are shown if custom SVGs aren't found
- This is normal behavior - the game is playable
- To add graphics, see [Customization Guide](customization.md)

### Can't move player

- Make sure you selected a character in the player selection screen
- Check console output for errors
- Verify platforms are present in the level scene

## Tips for Success

1. **Start Simple**: Generate with defaults first
2. **Iterate**: Make small changes and test frequently
3. **Use Config Files**: Easier to track and modify settings
4. **Version Control**: Use git to track your configurations
5. **Reference Examples**: Check `example_config.json` and `example_levels.json`

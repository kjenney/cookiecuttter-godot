# {{ cookiecutter.project_name }}

A 2D platformer game created with the [Godot 4 2D Platformer Builder](https://github.com/kjenney/cookiecutter-godot) template.

## Quick Start

1. **Open in Godot**
   ```bash
   godot project.godot
   ```

2. **Run the game**
   - Press **F5** or click the **Play** button
   - Select your player type
   - Use **Arrow Keys** or **A/D** to move
   - Press **SPACE** to jump

## Controls

- **Arrow Keys** or **A/D**: Move left/right
- **SPACE** or **W** or **UP**: Jump
- **Any Key**: Restart after game over

## Project Details

- **Game Mode**: {{ cookiecutter.game_mode }}
{% if cookiecutter.game_mode == "timed" -%}
- **Time Limit**: {{ cookiecutter.time_limit }} seconds
{% endif -%}
- **Target Score**: {{ cookiecutter.target_score }}
- **Levels**: {{ cookiecutter.level_count }}
- **Player Types**: {{ cookiecutter.player_types }}

## Testing

This project includes unit tests using [GUT (Godot Unit Test)](https://github.com/bitwes/Gut).

### Install GUT

Before running tests, install the GUT addon:

1. **Via AssetLib** (Easiest):
   - Open Godot
   - Click **AssetLib** tab
   - Search for "GUT"
   - Download and install

2. **Via GitHub** (Manual):
   ```bash
   # Download GUT
   wget -O gut.zip https://github.com/bitwes/Gut/archive/refs/tags/v9.3.0.zip
   unzip gut.zip

   # Copy to addons
   mkdir -p addons
   cp -r Gut-9.3.0/addons/gut addons/

   # Clean up
   rm -rf gut.zip Gut-9.3.0
   ```

3. **Enable Plugin**:
   - **Project → Project Settings → Plugins**
   - Check **Enable** next to "Gut"

### Run Tests

**In Godot Editor:**
1. Click **GUT** tab at bottom
2. Click **Run All**

**Command Line:**
```bash
godot --headless --path . -s addons/gut/gut_cmdln.gd -gexit
```

### Continuous Integration

This project includes a GitHub Actions workflow that automatically runs tests on push and pull requests.

**To enable:**
1. Install and commit GUT addon to the repository
2. Push your project to GitHub
3. Tests run automatically
4. View results in the **Actions** tab

**Important:** GUT addon must be in the repository for CI to work!

## Project Structure

```
{{ cookiecutter.project_slug }}/
├── project.godot          # Godot project configuration
├── scenes/                # Game scenes
│   ├── player.tscn       # Player character
│   ├── platform.tscn     # Platforms
│   ├── collectible.tscn  # Collectible items
{% if cookiecutter.include_npc == "yes" -%}
│   ├── npc.tscn          # NPCs
{% endif -%}
{% if cookiecutter.level_count|int > 1 -%}
│   ├── level_1.tscn      # Levels
│   └── ...
{% else -%}
│   └── main.tscn         # Main game scene
{% endif -%}
├── scripts/               # Game logic
│   ├── player.gd         # Player physics
│   ├── game_manager.gd   # Game state
{% if cookiecutter.level_count|int > 1 -%}
│   └── level_manager.gd  # Level transitions
{% endif -%}
├── assets/                # Graphics and audio
│   ├── player_*.svg      # Player sprites
{% if cookiecutter.include_npc == "yes" -%}
│   ├── npc*.svg          # NPC sprites
{% endif -%}
│   └── victory.wav       # Victory sound
└── tests/                 # Unit tests
    ├── test_player.gd
    └── ...
```

## Customization

### Change Physics

Edit `scripts/player.gd`:

```gdscript
@export var speed = 300.0         # Movement speed
@export var jump_velocity = -700.0  # Jump height
@export var gravity = 980.0       # Gravity strength
```

### Change Colors

Edit level backgrounds in scene files or `levels_config.json`.

### Add More Levels
{% if cookiecutter.level_count|int > 1 -%}
Edit `levels_config.json` to add or modify levels.
{% else -%}
Regenerate the project with `level_count` > 1.
{% endif -%}

## Documentation

Full documentation: [Godot 4 2D Platformer Builder Docs](https://kjenney.github.io/cookiecutter-godot/)

## License

This project was generated from the Godot 4 2D Platformer Builder template.

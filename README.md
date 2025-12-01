# Godot 4 2D Platformer Builder

A CookieCutter template for creating side-scrolling 2D platformer games in Godot 4 with configuration-driven development.

## Quick Start

```bash
# Install cookiecutter
pip install cookiecutter

# Generate your game
cookiecutter .

# Open in Godot
cd your_project_name
godot project.godot
```

Press **F5** to play!

## Features

- **🎮 Platformer Physics**: Gravity, jumping, and smooth horizontal movement
- **📜 Side-Scrolling Levels**: Camera follows player through horizontally scrolling levels
- **🎨 Multiple Player Types**: Choose between different character types at game start
- **⭐ Collectible System**: Items placed strategically on platforms
- **🎭 Sprite Animations**: Animated characters with idle, running, and collecting animations
- **💬 NPC Interactions**: Optional NPCs with speech bubbles and custom messages
- **🏆 Multiple Game Modes**: Endless, timed, or score target gameplay
- **📊 Multi-Level Support**: Create progressive campaigns with up to any number of levels
- **🎨 8 Layout Patterns**: Grid, circle, horizontal, vertical, diagonal, corners, random, scatter
- **🎵 Custom Assets**: Use your own SVG graphics and audio files
- **✅ Unit Tests**: Pre-configured GUT testing framework

## Prerequisites

- [Godot 4.0+](https://godotengine.org/download)
- [Cookiecutter](https://cookiecutter.readthedocs.io/en/latest/installation.html)

## Basic Usage

### Interactive Mode
```bash
cookiecutter .
# Answer prompts for each setting
```

### Command Line
```bash
cookiecutter . project_name="My Game" level_count="3" player_types="warrior,mage,rogue"
```

### Config File (Recommended)
```bash
cookiecutter . --no-input --config-file example_config.json
```

## Example Configuration

**example_config.json:**
```json
{
  "default_context": {
    "project_name": "My Adventure Game",
    "project_slug": "my_adventure_game",
    "player_types": "warrior,mage,rogue",
    "game_mode": "timed",
    "time_limit": "90",
    "level_count": "3",
    "levels_config": "./example_levels.json"
  }
}
```

**example_levels.json:**
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
        "message": "Welcome to Level 1!",
        "svg": ""
      }
    }
  ]
}
```

## Controls

- **Arrow Keys** or **A/D**: Move left/right
- **SPACE** or **W** or **UP**: Jump
- **Any Key**: Restart after game over

## Documentation

📚 **Full documentation is available in the [docs/](docs/) directory.**

### GitHub Pages

Documentation is automatically built and deployed to GitHub Pages on every push to `main`.

**To enable GitHub Pages for your fork:**

1. Go to your repository **Settings** → **Pages**
2. Under **Source**, select **GitHub Actions**
3. Push to `main` branch - the workflow will build and deploy automatically
4. Your docs will be available at `https://username.github.io/repository-name/`

### Local Development

To browse the documentation locally with MkDocs:

```bash
# Install mkdocs
pip install mkdocs mkdocs-material

# Serve documentation
mkdocs serve

# Open http://127.0.0.1:8000 in your browser
```

### Quick Links

- [📖 Installation Guide](docs/installation.md) - Get started with prerequisites
- [⚡ Quick Start](docs/quick-start.md) - Generate your first game in 5 minutes
- [⚙️ Configuration Guide](docs/configuration.md) - All configuration parameters
- [🎯 Level Configuration](docs/levels.md) - Create custom levels
- [🎮 Controls](docs/controls.md) - Player controls and input
- [🏃 Platformer Features](docs/platformer.md) - Physics system details
- [🎬 Animation System](docs/animations.md) - Sprite animations
- [📐 Collectible Layouts](docs/layouts.md) - 8 layout patterns
- [💡 Examples](docs/examples.md) - Configuration examples
- [🎨 Customization](docs/customization.md) - Modify your game
- [✅ Testing](docs/testing.md) - Unit testing with GUT
- [📁 Project Structure](docs/structure.md) - File organization

## What Gets Generated

```
your_project/
├── project.godot          # Godot project file
├── scenes/                # Game scenes
│   ├── player.tscn       # Player character
│   ├── platform.tscn     # Platforms
│   ├── collectible.tscn  # Collectibles
│   ├── npc.tscn          # NPCs
│   └── level_*.tscn      # Levels
├── scripts/               # GDScript files
│   ├── player.gd         # Player physics
│   ├── game_manager.gd   # Game logic
│   └── level_manager.gd  # Level transitions
├── assets/                # Graphics and audio
│   ├── player_*.svg      # Player sprites
│   ├── level_*_npc.svg   # NPC sprites
│   └── victory.wav       # Victory sound
└── tests/                 # Unit tests
    └── test_*.gd
```

## Game Modes

- **Endless**: Play at your own pace to reach the target score
- **Timed**: Race against the clock
- **Score Target**: Pure score focus

All modes support multi-level progression with player persistence.

## Customization Quick Tips

### Change Player Speed
```gdscript
# In scripts/player.gd
@export var speed = 400.0  # Default: 300.0
```

### Change Jump Height
```gdscript
@export var jump_velocity = -900.0  # Default: -700.0
```

### Change Background Color
```json
{
  "background_color": "#FF0000"
}
```

See [Customization Guide](docs/customization.md) for more options.

## Testing

The template includes unit tests using [GUT (Godot Unit Test)](https://github.com/bitwes/Gut).

### Local Testing

Run tests locally:
```bash
godot --headless -s addons/gut/gut_cmdln.gd -gexit
```

### Continuous Integration

Each generated project includes a **GitHub Actions workflow** that automatically runs tests on push and pull requests.

**Features:**
- ✅ Automatic testing in CI/CD
- ✅ Godot binary caching
- ✅ Test result summaries
- ✅ Downloadable test logs

**To enable:** Push your project to GitHub and the workflow runs automatically!

See [Testing Guide](docs/testing.md) for complete details on headless testing, CI/CD integration, and more.

## Examples

### RPG Adventure
```bash
cookiecutter . \
  project_name="RPG Quest" \
  player_types="warrior,mage,rogue" \
  custom_player_svgs="warrior:~/warrior.svg,mage:~/mage.svg,rogue:~/rogue.svg" \
  level_count="3"
```

### Speed Runner
```bash
cookiecutter . \
  project_name="Speed Runner" \
  game_mode="timed" \
  time_limit="30" \
  target_score="50" \
  include_npc="no"
```

More examples in [Examples Guide](docs/examples.md).

## Contributing

Feel free to fork and customize this template for your own needs!

## License

This template is provided as-is for educational and commercial use.

## Links

- [Godot Engine](https://godotengine.org/)
- [Cookiecutter](https://cookiecutter.readthedocs.io/)
- [GUT Testing Framework](https://github.com/bitwes/Gut)

---

**Need Help?** Check the [full documentation](docs/) or open an issue!

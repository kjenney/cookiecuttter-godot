# Godot 4 2D Collectible Game Template

A CookieCutter template for creating a simple 2D game in Godot 4 with a character that walks around and collects objects.

## Features

- **Player Selection**: Choose between different player types (Blue, Red, Green) at game start
- **Player Character**: CharacterBody2D with WASD/Arrow key movement
- **Collectible Objects**: Area2D objects that disappear when collected
- **Score Tracking**: Basic game manager with score system
- **Clean Structure**: Organized scenes and scripts folders
- **Ready to Extend**: Simple foundation for building more complex games

## Prerequisites

- [Godot 4.0+](https://godotengine.org/download)
- [Cookiecutter](https://cookiecutter.readthedocs.io/en/latest/installation.html)

## Installation

Install Cookiecutter if you haven't already:

```bash
pip install cookiecutter
```

## Usage

Create a new project from this template:

```bash
cookiecutter .
```

You can also pass values directly without prompts:

```bash
cookiecutter . project_name="My Game" player_types="warrior,mage" custom_player_svg=/path/to/character.svg
```

You'll be prompted to enter:
- **project_name**: Display name of your game (e.g., "My Awesome Game")
- **project_slug**: Folder name for your project (e.g., "my_awesome_game")
- **author_name**: Your name
- **godot_version**: Godot version (default: "4.5")
- **player_types**: Comma-separated list of player types available in-game (default: "blue,red,green")
  - Examples: "blue,red,green", "red,blue", "blue", "warrior,mage,rogue"
  - The in-game menu will dynamically show only these options
- **custom_player_svg**: Path to a custom SVG file for the player character (optional)
  - Leave empty to use the default player sprite
  - Provide an absolute path to your own 128x128 SVG file
  - Example: `/path/to/my-character.svg`

## Project Structure

```
your_project/
├── project.godot          # Godot project configuration
├── icon.svg              # Project icon
├── scenes/               # Scene files (.tscn)
│   ├── player.tscn      # Player character scene
│   ├── collectible.tscn # Collectible object scene
│   ├── player_select.tscn # Player selection menu
│   └── main.tscn        # Main game scene
├── scripts/             # GDScript files (.gd)
│   ├── player.gd        # Player movement logic
│   ├── collectible.gd   # Collectible behavior
│   ├── player_select.gd # Player selection menu logic
│   └── game_manager.gd  # Score tracking and game state
└── assets/              # Game assets (images, sounds, etc.)
    └── player.svg       # Player character sprite (customizable via custom_player_svg)
```

## Getting Started

1. Open the generated project in Godot 4
2. Press F5 or click the Play button to run the game
3. Select your preferred player type (Blue, Red, or Green)
4. Click "Start Game" to begin
5. Use WASD or Arrow keys to move the player
6. Collect the golden objects to increase your score
7. Check the console output to see your score

## Customization Ideas

- **Custom Player**: Use the `custom_player_svg` option to provide your own player character SVG, or edit `assets/player.svg` after generation
- **More Collectibles**: Add different types of collectibles with varying point values
- **UI**: Add a score display on screen using a CanvasLayer
- **Sound Effects**: Add audio when collecting objects
- **Enemies**: Create enemy characters that the player must avoid
- **Levels**: Design multiple levels with different layouts
- **Power-ups**: Add special collectibles that give temporary abilities

## Testing

The template includes unit tests in the `tests/` folder using a minimal GUT (Godot Unit Test) stub. To run tests with full functionality:

1. Install the GUT addon from Godot's AssetLib (search for "GUT") or from [GitHub](https://github.com/bitwes/Gut)
2. Replace the `addons/gut/` folder with the full GUT addon
3. Enable the plugin in Project Settings > Plugins
4. Run tests via the GUT panel

## Controls

- **Arrow Keys** or **WASD**: Move the player character

## License

This template is provided as-is for educational and commercial use.

## Contributing

Feel free to fork and customize this template for your own needs!

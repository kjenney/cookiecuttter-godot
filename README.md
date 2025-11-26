# Godot 4 2D Builder

A CookieCutter template for creating a 2D game in Godot 4 that uses CookieCutter configuration to guide how the game is built.

## Features

- **Player Selection**: Choose between different player types (Blue, Red, Green) at game start
- **Player Character**: CharacterBody2D with WASD/Arrow key movement
- **Collectible Objects**: Area2D objects that disappear when collected
- **NPC with Speech Bubble**: Optional NPC that displays a speech bubble when the player approaches
- **Score Tracking**: On-screen UI with score display and game mode information
- **Multiple Game Modes**: Choose between endless, timed, or score target gameplay
  - **Endless Mode**: Play at your own pace to reach the target score
  - **Timed Mode**: Race against time to reach the target score before time runs out
  - **Score Target Mode**: Focus purely on reaching the target score (same as endless but with clearer intent)
- **Multi-Level Support**: Create games with multiple progressive levels
  - **Auto-Generated Levels**: Automatically create levels with increasing difficulty
  - **Custom Level Configuration**: Full control via JSON for each level's properties
  - **Level-Specific NPCs**: Each level can have unique NPCs with custom messages
  - **Player Persistence**: Selected character type carries across all levels
- **Victory Feedback**: Auto-generated victory sound plays when winning (customizable)
- **Quick Restart**: Press any key (SPACE, ENTER, arrows) to instantly restart after game over
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

### Option 1: Interactive Mode (Prompts)

Create a new project and answer prompts for each configuration option:

```bash
cookiecutter .
```

You will be prompted for all configuration values (project_name, player_types, game_mode, level_count, etc.)

### Option 2: Command-Line Arguments

Pass values directly without prompts:

```bash
cookiecutter . project_name="My Game" player_types="warrior,mage" custom_player_svgs="warrior:/path/to/warrior.svg,mage:/path/to/mage.svg"
```

### Option 3: Config File (Recommended for complex setups)

Use a JSON config file to specify only the values you want to customize:

```bash
cookiecutter . --no-input --config-file example_config.json
```

**Important Notes:**
- Cookiecutter config files must use the `default_context` wrapper
- You only need to specify parameters you want to change from their defaults (defined in `cookiecutter.json`)
- Any omitted parameters will use their default values automatically
- The `levels_config` parameter inside the config can reference a SEPARATE JSON file for level definitions

Example `example_config.json`:
```json
{
  "default_context": {
    "project_name": "My Adventure Game",
    "project_slug": "my_adventure_game",
    "author_name": "Your Name",
    "godot_version": "4.5",
    "player_types": "warrior,mage,rogue",
    "custom_player_svgs": "",
    "include_npc": "yes",
    "custom_npc_svg": "",
    "game_mode": "endless",
    "time_limit": "60",
    "target_score": "100",
    "victory_sound": "",
    "level_count": "3",
    "levels_config": "./example_levels.json"
  }
}
```

**Minimal Config Example** (only customize what you need):
```json
{
  "default_context": {
    "project_name": "My Game",
    "project_slug": "my_game",
    "level_count": "3",
    "levels_config": "./example_levels.json"
  }
}
```
This minimal config will use defaults for all other parameters (include_npc="yes", game_mode="endless", player_types="blue,red,green", etc.)

The repository includes:
- `example_config.json` - Complete example showing all available parameters
- `example_levels.json` - Level definitions referenced by the `levels_config` parameter

### Configuration Parameters

The following parameters are available. Default values (from `cookiecutter.json`) are shown in parentheses. You only need to specify values you want to override:

- **project_name**: Display name of your game (e.g., "My Awesome Game")
- **project_slug**: Folder name for your project (e.g., "my_awesome_game")
- **author_name**: Your name
- **godot_version**: Godot version (default: "4.5")
- **player_types**: Comma-separated list of player types available in-game (default: "blue,red,green")
  - Examples: "blue,red,green", "red,blue", "blue", "warrior,mage,rogue"
  - The in-game menu will dynamically show only these options
- **custom_player_svgs**: Paths to type-specific SVG files for each player type (optional)
  - Format: `"type1:path1,type2:path2,type3:path3"`
  - Example: `"blue:~/blue_hero.svg,red:~/red_warrior.svg,green:~/green_mage.svg"`
  - This allows completely different character designs for each player type
  - Leave empty to use the default player sprite with color modulation
  - Supports absolute paths, relative paths, and `~` expansion
  - Types not specified will use the default SVG
  - To use the same custom SVG for all types: `"blue:~/hero.svg,red:~/hero.svg,green:~/hero.svg"`
- **include_npc**: Include an NPC in the game (default: "yes")
  - Set to "yes" to include an NPC that displays a speech bubble when approached
  - Set to "no" to exclude the NPC
- **custom_npc_svg**: Path to a custom SVG file for the NPC (optional)
  - **SINGLE-LEVEL MODE ONLY** (when `level_count: "1"`)
  - This sets a global NPC sprite used in the single main scene
  - Leave empty to use the default NPC sprite
  - Supports absolute paths, relative paths, and `~` expansion
  - Examples: `/path/to/npc.svg`, `./assets/npc.svg`, `~/images/npc.svg`
  - **For multi-level games**: Ignore this parameter and specify NPC SVGs per-level in your `levels_config` JSON file instead (see "Multi-Level Configuration" below)
- **game_mode**: Game mode to use (default: "endless")
  - Options: "endless", "timed", "score_target"
  - **endless**: Play indefinitely with a target score to reach
  - **timed**: Race against the clock to reach the target score before time runs out
  - **score_target**: Focus solely on reaching the target score (no time pressure)
- **time_limit**: Time limit in seconds for timed mode (default: "60")
  - Only used when game_mode is "timed"
  - Example: "30", "120", "300"
- **target_score**: Target score to win the game (default: "100")
  - **Applies to ALL game modes** - reaching this score triggers victory
  - Example: "50", "200", "500"
- **victory_sound**: Path to a custom WAV/OGG file for the victory sound (optional)
  - Leave empty to use the auto-generated victory chime
  - Supports absolute paths, relative paths, and `~` expansion
  - Example: `/path/to/victory.wav`, `./sounds/win.ogg`
- **level_count**: Number of levels in the game (default: "1")
  - Set to "1" for single-level games
  - Set to "2" or higher for multi-level progression
  - Example: "3", "5", "10"
  - When > 1, the game creates multiple levels with increasing difficulty
- **levels_config**: Path to a JSON file defining custom level configuration (optional)
  - Leave empty to auto-generate levels with default settings
  - Use a custom JSON file for full control over each level's properties
  - Supports absolute paths, relative paths, and `~` expansion
  - See "Multi-Level Configuration" section below for JSON format
  - Example: `./my_levels.json`, `~/game_configs/levels.json`

## Project Structure

```
your_project/
├── project.godot          # Godot project configuration
├── icon.svg              # Project icon
├── levels_config.json    # Level configuration (if level_count > 1)
├── scenes/               # Scene files (.tscn)
│   ├── player.tscn      # Player character scene
│   ├── collectible.tscn # Collectible object scene
│   ├── npc.tscn         # NPC scene (if include_npc=yes)
│   ├── player_select.tscn # Player selection menu
│   ├── ui_layer.tscn    # UI overlay for score and game mode info
│   ├── main.tscn        # Main game scene (single-level mode)
│   ├── level_1.tscn     # Level 1 scene (multi-level mode)
│   ├── level_2.tscn     # Level 2 scene (multi-level mode)
│   └── ...              # Additional levels (if level_count > 2)
├── scripts/             # GDScript files (.gd)
│   ├── player.gd        # Player movement logic
│   ├── collectible.gd   # Collectible behavior
│   ├── npc.gd           # NPC behavior (if include_npc=yes)
│   ├── player_select.gd # Player selection menu logic
│   ├── ui_layer.gd      # UI layer management
│   ├── level_manager.gd # Level transitions and state (if level_count > 1)
│   └── game_manager.gd  # Score tracking, game state, and game mode logic
└── assets/              # Game assets (images, sounds, etc.)
    ├── player_blue.svg  # Blue player sprite (customizable via custom_player_svgs)
    ├── player_red.svg   # Red player sprite (customizable via custom_player_svgs)
    ├── player_green.svg # Green player sprite (customizable via custom_player_svgs)
    ├── npc.svg          # NPC sprite (if include_npc=yes, customizable via custom_npc_svg)
    ├── level_1_npc.svg  # Level 1 NPC sprite (multi-level mode)
    ├── level_2_npc.svg  # Level 2 NPC sprite (multi-level mode)
    ├── ...              # Additional level NPCs
    └── victory.wav      # Victory sound (auto-generated or customizable via victory_sound)
```

## Getting Started

1. Open the generated project in Godot 4
2. Press F5 or click the Play button to run the game
3. **Player Selection Screen**:
   - Use **arrow keys** or **click** to choose your player type
   - Press **ENTER** or **SPACE** (or click "Start Game") to begin
   - Selected option is highlighted with arrows (→ Player ←) and brighter color
4. Use WASD or Arrow keys to move the player
5. Collect the golden objects to increase your score
6. Walk near the NPC to see a speech bubble appear (if enabled)
7. Watch the on-screen UI for your score and game mode information

### Game Mode Behaviors

**All game modes have a target score** - reaching it triggers victory with a sound effect!

- **Endless Mode**: No time pressure. Take as long as you need to reach the target score displayed in the top-left corner.
- **Timed Mode**: A countdown timer and target score appear in the top-left corner. Race to reach the target score before time runs out. You can win by reaching the target, or lose when time expires.
- **Score Target Mode**: Similar to endless mode - just the target score is shown. Purely focused on reaching that goal.

### Game Over and Restart

**Winning (reaching target score in any mode):**
1. Victory sound plays (pleasant 3-note chime)
2. Game pauses and displays "You win! Target score reached!"
3. Press **any key** (SPACE, ENTER, or arrow keys) to restart and play again

**Losing (timed mode only - time runs out):**
1. Game pauses and displays "Time's up! Final score: X"
2. Press **any key** (SPACE, ENTER, or arrow keys) to restart and try again

## Example Configurations

Create a timed challenge game:
```bash
cookiecutter . project_name="Speed Runner" game_mode=timed time_limit=30 include_npc=no
```

Create a score-based game with custom player:
```bash
cookiecutter . project_name="Gem Collector" game_mode=score_target target_score=200 custom_player_svgs="blue:~/my_character.svg,red:~/my_character.svg,green:~/my_character.svg"
```

Create a game with a custom victory sound:
```bash
cookiecutter . project_name="My Game" game_mode=score_target target_score=50 victory_sound=./sounds/victory.wav
```

Create a game with unique character designs for each player type:
```bash
cookiecutter . project_name="RPG Adventure" player_types="warrior,mage,rogue" custom_player_svgs="warrior:~/warrior.svg,mage:~/mage.svg,rogue:~/rogue.svg"
```

Create a 3-level game with auto-generated levels:
```bash
cookiecutter . project_name="Level Quest" level_count=3
```

Create a multi-level game with custom level configuration:
```bash
cookiecutter . project_name="Adventure Game" level_count=3 levels_config=./example_levels.json
```

Use a complete config file for a complex multi-level setup:
```bash
cookiecutter . --no-input --config-file example_config.json
```

This uses `example_config.json` (which contains ALL parameters including project_name, author_name, etc.) and references `example_levels.json` (which defines the level structure).

## Multi-Level Configuration

The template supports creating games with multiple levels that progressively increase in difficulty. When you set `level_count` to a value greater than 1, the game automatically creates multiple levels with:

- **Player Persistence**: Your selected player type carries across all levels
- **Level Progression**: Reaching the target score advances to the next level
- **Individual Level Scenes**: Each level has its own scene file with custom properties
- **Level-Specific NPCs**: Each level can have unique NPCs with different messages

### Configuration File Structure

When using config files for multi-level games, you work with TWO separate JSON files:

1. **Cookiecutter Config** (`example_config.json`) - Contains ALL template parameters
   - Base settings: project_name, author_name, godot_version, etc.
   - Game settings: player_types, game_mode, target_score, etc.
   - **levels_config parameter**: Path to the levels JSON file

2. **Levels Config** (`example_levels.json`) - Defines level-specific properties
   - Referenced BY the `levels_config` parameter in the cookiecutter config
   - Contains array of level objects with collectibles, NPCs, colors, etc.

**Workflow:**
```bash
# You pass ONE file to cookiecutter
cookiecutter . --no-input --config-file example_config.json

# Inside example_config.json, the levels_config parameter points to the second file
# "levels_config": "./example_levels.json"

# The post-generation hook reads example_levels.json to create the levels
```

### Auto-Generated Levels

If you don't provide a `levels_config` file, levels are auto-generated with increasing difficulty:

- **Collectibles**: Increases by 2 each level (Level 1: 4, Level 2: 6, Level 3: 8, etc.)
- **Target Score**: Increases by 20 each level (Level 1: 40, Level 2: 60, Level 3: 80, etc.)
- **Background Color**: Varies slightly per level
- **NPCs**: If enabled, each level gets a unique NPC with a welcome message

### Custom Level Configuration

For full control, create a JSON file defining each level's properties. The template includes `example_levels.json` as a reference:

```json
{
  "levels": [
    {
      "name": "level_1",
      "npc": {
        "enabled": true,
        "type": "guide",
        "message": "Welcome to Level 1! Collect 40 points to advance.",
        "svg": ""
      },
      "collectibles": 4,
      "target_score": 40,
      "background_color": "#1a1a1a"
    },
    {
      "name": "level_2",
      "npc": {
        "enabled": true,
        "type": "warrior",
        "message": "Level 2 is tougher! Reach 60 points!",
        "svg": ""
      },
      "collectibles": 6,
      "target_score": 60,
      "background_color": "#2a1a2a"
    },
    {
      "name": "level_3",
      "npc": {
        "enabled": true,
        "type": "boss",
        "message": "Final level! Get 80 points to win!",
        "svg": ""
      },
      "collectibles": 8,
      "target_score": 80,
      "background_color": "#3a1a1a"
    },
    {
      "name": "celebration",
      "celebration_level": true,
      "auto_win_delay": 5,
      "npc": {
        "enabled": true,
        "type": "victory",
        "message": "Congratulations! You've completed all levels!",
        "svg": ""
      },
      "collectibles": 0,
      "target_score": 0,
      "background_color": "#1a3a1a"
    }
  ]
}
```

### Level Configuration Properties

Each level in the JSON array can have the following properties:

- **name** (required): Scene filename (e.g., "level_1", "tutorial_stage", "boss_fight", "celebration")
- **collectibles** (required): Number of collectible items to spawn
- **target_score** (required): Score needed to complete this level (set to 0 for celebration levels)
- **background_color** (required): Hex color for the level background (e.g., "#1a1a1a")
- **celebration_level** (optional): Set to `true` to create a celebration level (default: `false`)
  - Celebration levels automatically win after a delay - no score needed
  - Perfect for victory screens after completing all challenging levels
  - Hides score/target UI elements
  - See `auto_win_delay` below
- **auto_win_delay** (optional): Seconds to wait before auto-winning on celebration levels (default: 5)
  - Only used when `celebration_level: true`
  - Victory sound plays automatically after this delay
  - Example: `"auto_win_delay": 5` waits 5 seconds then shows victory
- **npc** (optional): NPC configuration for this level
  - **enabled**: `true` to include an NPC in this level, `false` to exclude
  - **type**: Descriptive type name for documentation purposes (e.g., "guide", "warrior", "boss")
  - **message**: Text displayed in the speech bubble when player approaches the NPC
  - **svg**: Path to a custom SVG file for **this specific level's NPC**
    - Supports absolute paths, relative paths, and `~` expansion
    - Examples: `"./assets/svgs/damsel.svg"`, `"~/images/boss.svg"`, `"/path/to/npc.svg"`
    - Leave as empty string `""` to use a default NPC sprite
    - Each level can have its own unique NPC appearance
    - **This is independent of** the `custom_npc_svg` parameter (which only applies to single-level games)

### Multi-Level Game Flow

1. **Game Start**: Player selects their character type (only shown on first level)
2. **Play Level**: Collect items to reach the target score
3. **Level Complete**: Victory sound plays, then automatically advances to next level
4. **Next Level**: Same player character, new level layout and target
5. **Game Complete**: After completing all levels, shows final victory message
6. **Restart**: Press any key to restart from Level 1

### Notes

- **Single Player Selection**: The player selection screen only appears once at the start of the game
- **Player Persistence**: Your chosen player type is maintained across all levels
- **Unique NPCs**: Each level can have its own NPC with a custom message and appearance
- **Progressive Difficulty**: Design levels to gradually increase in challenge (more collectibles, higher scores, etc.)
- **Extensible Format**: The JSON format allows adding custom properties for future features

### NPC Configuration Quick Reference

Understanding when to use `custom_npc_svg` vs. level-specific NPC SVGs:

**Single-Level Games** (`level_count: "1"`):
- Use the `custom_npc_svg` parameter in your cookiecutter config
- This sets a global NPC sprite for the single main scene
- Example:
  ```json
  {
    "default_context": {
      "level_count": "1",
      "custom_npc_svg": "./my_npc.svg"
    }
  }
  ```

**Multi-Level Games** (`level_count: "2"` or higher):
- Ignore the `custom_npc_svg` parameter entirely
- Instead, specify NPC SVGs per-level in your `levels_config` JSON file
- Each level can have a different NPC sprite
- Example in `example_levels.json`:
  ```json
  {
    "levels": [
      {
        "name": "level_1",
        "npc": {
          "enabled": true,
          "message": "Welcome!",
          "svg": "./assets/svgs/friendly_npc.svg"
        }
      },
      {
        "name": "level_2",
        "npc": {
          "enabled": true,
          "message": "Tougher challenge!",
          "svg": "./assets/svgs/warrior_npc.svg"
        }
      }
    ]
  }
  ```

## Customization Ideas

- **Custom Player**: Use `custom_player_svgs` to provide unique character designs for each player type (warrior, mage, rogue, etc.), or use the same SVG for all types
- **Unique Character Classes**: Create visually distinct characters for each player type - e.g., a knight for "warrior", wizard for "mage", archer for "rogue"
- **Game Modes**: Mix and match game modes with different time limits and target scores for varied gameplay
- **Multi-Level Adventures**: Use the level configuration system to create progressive campaigns with increasing difficulty
- **Themed Levels**: Design levels with unique visual themes, collectible counts, and NPCs for storytelling
- **More Collectibles**: Add different types of collectibles with varying point values
- **Sound Effects**: Add audio when collecting objects or when the timer is running low
- **Enemies**: Create enemy characters that the player must avoid
- **Power-ups**: Add special collectibles that give temporary abilities or bonus time

## Testing

The template includes unit tests in the `tests/` folder using [GUT (Godot Unit Test)](https://github.com/bitwes/Gut). To run tests:

1. Install the GUT addon from Godot's AssetLib (search for "GUT") or from [GitHub](https://github.com/bitwes/Gut)
2. Replace the `addons/gut/` folder with the full GUT addon
3. Enable the plugin in Project Settings > Plugins
4. Configure test directories in the GUT panel:
   - Click the **GUT** tab in the bottom panel
   - Click the **settings gear icon** on the right
   - Under **Directories**, add: `res://tests`
   - Check **Include Subdirs** if desired
5. Click **Run All** to run tests

A `.gutconfig.json` file is included for command-line testing:
```bash
godot --headless -s addons/gut/gut_cmdln.gd
```

## Controls

### Player Selection
- **Arrow Keys** (←/→ or ↑/↓): Navigate between player options
- **ENTER** or **SPACE**: Start the game with selected player
- **Mouse Click**: Click buttons to select or start

### Gameplay
- **Arrow Keys** or **WASD**: Move the player character

### Game Over
- **Any Key** (SPACE, ENTER, or arrows): Restart the game

## License

This template is provided as-is for educational and commercial use.

## Contributing

Feel free to fork and customize this template for your own needs!

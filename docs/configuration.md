# Configuration Guide

Complete reference for all configuration parameters in the Godot 4 2D Platformer Builder.

## Configuration Methods

There are three ways to configure your game project:

### 1. Interactive Mode

Run cookiecutter and answer prompts:

```bash
cookiecutter .
```

You'll be prompted for each parameter. Press Enter to accept defaults.

### 2. Command-Line Arguments

Pass parameters directly:

```bash
cookiecutter . project_name="My Game" player_types="warrior,mage" level_count=3
```

### 3. Configuration File (Recommended)

Use a JSON file for complex setups:

```bash
cookiecutter . --no-input --config-file my_config.json
```

**Config file structure:**
```json
{
  "default_context": {
    "project_name": "My Game",
    "project_slug": "my_game",
    "level_count": "3"
  }
}
```

!!! note "Important"
    - Config files must use the `default_context` wrapper
    - Only specify parameters you want to override
    - Omitted parameters use defaults from `cookiecutter.json`

## Configuration Parameters

### Project Settings

#### project_name
- **Type**: String
- **Default**: "My Platformer Game"
- **Description**: Display name of your game
- **Example**: `"My Adventure Quest"`

#### project_slug
- **Type**: String
- **Default**: "my_platformer_game"
- **Description**: Folder name for the generated project
- **Example**: `"adventure_quest"`
- **Rules**: Lowercase, underscores only, no spaces

#### author_name
- **Type**: String
- **Default**: "Your Name"
- **Description**: Your name or studio name
- **Example**: `"Game Studios Inc."`

#### godot_version
- **Type**: String
- **Default**: "4.5"
- **Description**: Godot version compatibility
- **Example**: `"4.5"`, `"4.3"`

### Player Configuration

#### player_types
- **Type**: Comma-separated string
- **Default**: `"blue,red,green"`
- **Description**: Available player types in selection menu
- **Examples**:
  - `"blue,red,green"` - Default color-based
  - `"warrior,mage,rogue"` - RPG classes
  - `"blue"` - Single player type
- **Notes**: 
  - Player selection menu dynamically shows these options
  - Each type can have a unique sprite via `custom_player_svgs`

#### custom_player_svgs
- **Type**: Comma-separated key:value pairs
- **Default**: `""` (empty - uses default sprites)
- **Description**: Paths to custom SVG files for each player type
- **Format**: `"type1:path1,type2:path2,type3:path3"`
- **Examples**:
  - `"blue:~/hero.svg,red:~/warrior.svg,green:~/mage.svg"`
  - `"warrior:/path/to/warrior.svg,mage:/path/to/mage.svg"`
- **Path Support**:
  - Absolute paths: `/Users/name/sprites/hero.svg`
  - Relative paths: `./assets/hero.svg`
  - Home expansion: `~/game_assets/hero.svg`
- **Notes**:
  - Leave empty to use default colored rectangles
  - Types not specified use the default sprite
  - Same SVG can be reused: `"blue:~/hero.svg,red:~/hero.svg"`

### NPC Configuration

#### include_npc
- **Type**: String ("yes" or "no")
- **Default**: `"yes"`
- **Description**: Include NPCs in the game
- **Options**:
  - `"yes"` - NPCs enabled with speech bubbles
  - `"no"` - No NPCs generated

#### custom_npc_svg
- **Type**: String (file path)
- **Default**: `""` (empty - uses default sprite)
- **Description**: Custom SVG for NPC sprite
- **Scope**: **Single-level games only** (`level_count: "1"`)
- **Examples**:
  - `"./assets/npc.svg"`
  - `"~/characters/guide.svg"`
  - `"/path/to/damsel.svg"`
- **Path Support**: Same as `custom_player_svgs`
- **Multi-Level Note**: For multi-level games, use per-level NPC SVGs in `levels_config` instead

### Game Mode Settings

#### game_mode
- **Type**: String
- **Default**: `"endless"`
- **Description**: Core gameplay mode
- **Options**:
  - `"endless"` - No time pressure, reach target score
  - `"timed"` - Race against countdown timer
  - `"score_target"` - Pure score focus (similar to endless)
- **Examples**:
  ```json
  "game_mode": "timed"
  ```

#### time_limit
- **Type**: String (number in seconds)
- **Default**: `"60"`
- **Description**: Time limit for timed mode
- **Examples**: `"30"`, `"120"`, `"300"`
- **Notes**: Only affects `game_mode: "timed"`

#### target_score
- **Type**: String (number)
- **Default**: `"100"`
- **Description**: Score needed to win (applies to ALL modes)
- **Examples**: `"50"`, `"200"`, `"500"`
- **Notes**: Victory triggers when player reaches this score

### Audio Settings

#### victory_sound
- **Type**: String (file path)
- **Default**: `""` (empty - auto-generates sound)
- **Description**: Custom victory sound file
- **Supported Formats**: WAV, OGG
- **Examples**:
  - `"./sounds/victory.wav"`
  - `"~/audio/win.ogg"`
  - `"/path/to/fanfare.wav"`
- **Path Support**: Same as `custom_player_svgs`
- **Notes**: Leave empty for built-in victory chime

### Level Configuration

#### level_count
- **Type**: String (number)
- **Default**: `"1"`
- **Description**: Number of levels in the game
- **Examples**: `"1"`, `"3"`, `"5"`, `"10"`
- **Behavior**:
  - `"1"` - Single-level game (uses `main.tscn`)
  - `"2+"` - Multi-level game (uses `level_1.tscn`, `level_2.tscn`, etc.)
  - Auto-generates levels if no `levels_config` provided

#### levels_config
- **Type**: String (file path)
- **Default**: `""` (empty - auto-generates levels)
- **Description**: Path to JSON file defining level properties
- **Examples**:
  - `"./example_levels.json"`
  - `"~/configs/my_levels.json"`
  - `"/path/to/levels.json"`
- **Path Support**: Same as `custom_player_svgs`
- **Notes**:
  - Leave empty for auto-generated levels
  - See [Level Configuration](levels.md) for JSON format
  - Referenced file is separate from cookiecutter config

## Configuration File Examples

### Minimal Configuration

Override only essential parameters:

```json
{
  "default_context": {
    "project_name": "Quick Game",
    "project_slug": "quick_game"
  }
}
```

Uses all defaults: endless mode, 1 level, blue/red/green players, etc.

### Custom Player Types

RPG-style game with custom sprites:

```json
{
  "default_context": {
    "project_name": "RPG Adventure",
    "project_slug": "rpg_adventure",
    "player_types": "warrior,mage,rogue",
    "custom_player_svgs": "warrior:~/sprites/warrior.svg,mage:~/sprites/mage.svg,rogue:~/sprites/rogue.svg"
  }
}
```

### Timed Challenge Game

30-second speed run:

```json
{
  "default_context": {
    "project_name": "Speed Runner",
    "project_slug": "speed_runner",
    "game_mode": "timed",
    "time_limit": "30",
    "target_score": "50",
    "include_npc": "no"
  }
}
```

### Multi-Level Campaign

3-level game with custom configuration:

```json
{
  "default_context": {
    "project_name": "Adventure Quest",
    "project_slug": "adventure_quest",
    "level_count": "3",
    "levels_config": "./my_levels.json",
    "game_mode": "endless"
  }
}
```

### Complete Custom Setup

Full customization example:

```json
{
  "default_context": {
    "project_name": "My Adventure Game",
    "project_slug": "my_adventure_game",
    "author_name": "Game Dev Studio",
    "godot_version": "4.5",
    "player_types": "warrior,mage,rogue",
    "custom_player_svgs": "warrior:~/warrior.svg,mage:~/mage.svg,rogue:~/rogue.svg",
    "include_npc": "yes",
    "game_mode": "timed",
    "time_limit": "90",
    "target_score": "150",
    "victory_sound": "~/audio/victory.wav",
    "level_count": "4",
    "levels_config": "./adventure_levels.json"
  }
}
```

## Two-File Configuration Pattern

For complex multi-level games, use TWO configuration files:

### 1. Cookiecutter Config (`my_config.json`)

Contains all template parameters:

```json
{
  "default_context": {
    "project_name": "My Game",
    "project_slug": "my_game",
    "player_types": "warrior,mage",
    "game_mode": "endless",
    "level_count": "3",
    "levels_config": "./my_levels.json"
  }
}
```

### 2. Levels Config (`my_levels.json`)

Defines level-specific properties:

```json
{
  "levels": [
    {
      "name": "level_1",
      "collectibles": 4,
      "target_score": 40,
      "background_color": "#1a1a1a",
      "layout": "grid"
    }
  ]
}
```

### Usage

```bash
# Pass only the cookiecutter config
cookiecutter . --no-input --config-file my_config.json

# The levels_config parameter points to the second file
# Both files work together to create the complete game
```

## Default Values Reference

All defaults from `cookiecutter.json`:

| Parameter | Default Value |
|-----------|---------------|
| project_name | "My Platformer Game" |
| project_slug | "my_platformer_game" |
| author_name | "Your Name" |
| godot_version | "4.5" |
| player_types | "blue,red,green" |
| custom_player_svgs | "" |
| include_npc | "yes" |
| custom_npc_svg | "" |
| game_mode | "endless" |
| time_limit | "60" |
| target_score | "100" |
| victory_sound | "" |
| level_count | "1" |
| levels_config | "" |

## Parameter Validation

### Common Mistakes

**Wrong:**
```json
{
  "project_name": "My Game"
}
```
Missing `default_context` wrapper.

**Correct:**
```json
{
  "default_context": {
    "project_name": "My Game"
  }
}
```

**Wrong:**
```json
{
  "default_context": {
    "level_count": 3
  }
}
```
Numbers must be strings.

**Correct:**
```json
{
  "default_context": {
    "level_count": "3"
  }
}
```

### Path Guidelines

- **Absolute paths**: Start with `/` (Unix) or `C:\` (Windows)
- **Relative paths**: Start with `./` or `../`
- **Home expansion**: Use `~/` for user home directory
- **Spaces**: Supported in paths (automatically handled)

## Next Steps

- [Level Configuration](levels.md) - Configure individual levels
- [Examples](examples.md) - See complete configuration examples
- [Quick Start](quick-start.md) - Generate your first game

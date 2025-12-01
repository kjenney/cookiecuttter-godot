# Level Configuration

Complete guide to creating and configuring levels in your platformer game.

## Overview

The template supports both single-level and multi-level games. When `level_count` is set to 2 or higher, you can create progressive platforming campaigns with unique properties for each level.

## Configuration Methods

### Auto-Generated Levels

If you don't provide a `levels_config` file, levels are automatically generated with increasing difficulty:

```bash
cookiecutter . project_name="My Game" level_count="3"
```

**Auto-generation rules:**
- **Collectibles**: Increases by 2 each level (Level 1: 4, Level 2: 6, Level 3: 8)
- **Target Score**: 10 points per collectible (Level 1: 40, Level 2: 60, Level 3: 80)
- **Background Color**: Varies per level
- **Layout**: Grid pattern (default)
- **NPCs**: Each level gets a unique NPC with welcome message

### Custom Level Configuration

For full control, create a JSON file defining each level:

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
    },
    {
      "name": "level_2",
      "collectibles": 6,
      "target_score": 60,
      "background_color": "#2a1a2a",
      "layout": "horizontal",
      "npc": {
        "enabled": true,
        "message": "Level 2 is harder!",
        "svg": "./assets/warrior.svg"
      }
    }
  ]
}
```

Save as `my_levels.json` and reference it:

```bash
cookiecutter . project_name="My Game" level_count="2" levels_config="./my_levels.json"
```

## Level Properties

### Required Properties

#### name
- **Type**: String
- **Description**: Scene filename (without .tscn extension)
- **Examples**: `"level_1"`, `"tutorial"`, `"boss_fight"`, `"celebration"`
- **Rules**: Must be unique, lowercase recommended

#### collectibles
- **Type**: Integer
- **Description**: Number of collectible items to spawn
- **Range**: 0-20 recommended
- **Examples**: `4`, `8`, `12`
- **Notes**: Set to 0 for celebration levels

#### target_score
- **Type**: Integer
- **Description**: Score needed to complete level
- **Calculation**: Usually `collectibles * 10`
- **Examples**: `40`, `60`, `100`
- **Notes**: Set to 0 for auto-win celebration levels

#### background_color
- **Type**: String (hex color)
- **Description**: Level background color
- **Format**: `"#RRGGBB"`
- **Examples**:
  - `"#1a1a1a"` - Dark gray
  - `"#2a1a2a"` - Dark purple
  - `"#1a3a1a"` - Dark green
  - `"#3a1a1a"` - Dark red

### Optional Properties

#### layout
- **Type**: String
- **Default**: `"grid"`
- **Description**: Collectible placement pattern
- **Options**:
  - `"grid"` - Rows and columns (default)
  - `"circle"` - Circular pattern
  - `"horizontal"` - Single horizontal line
  - `"vertical"` - Single vertical line
  - `"diagonal"` - Diagonal line
  - `"corners"` - Four corners + center
  - `"random"` - Random with spacing
  - `"scatter"` - Wide random spacing
- **See**: [Collectible Layouts](layouts.md) for details

#### celebration_level
- **Type**: Boolean
- **Default**: `false`
- **Description**: Auto-win victory level
- **Usage**: Final level that automatically wins after delay
- **Example**:
  ```json
  {
    "name": "celebration",
    "celebration_level": true,
    "auto_win_delay": 5,
    "collectibles": 0,
    "target_score": 0
  }
  ```

#### auto_win_delay
- **Type**: Integer (seconds)
- **Default**: `5`
- **Description**: Delay before auto-win on celebration levels
- **Range**: 1-60 seconds recommended
- **Notes**: Only used when `celebration_level: true`

#### npc
- **Type**: Object
- **Description**: NPC configuration for this level
- **Structure**:
  ```json
  {
    "enabled": true,
    "type": "guide",
    "message": "Welcome!",
    "svg": "./path/to/npc.svg"
  }
  ```

##### npc.enabled
- **Type**: Boolean
- **Description**: Include NPC in this level
- **Default**: `true`

##### npc.type
- **Type**: String
- **Description**: Descriptive type name (documentation only)
- **Examples**: `"guide"`, `"warrior"`, `"boss"`, `"victory"`

##### npc.message
- **Type**: String
- **Description**: Speech bubble text
- **Length**: 1-100 characters recommended
- **Examples**:
  - `"Welcome to Level 1!"`
  - `"Collect 40 points to advance!"`
  - `"Final challenge ahead!"`

##### npc.svg
- **Type**: String (file path)
- **Description**: Custom NPC sprite for this level
- **Default**: `""` (uses default sprite)
- **Path Support**: Absolute, relative, `~` expansion
- **Examples**:
  - `"./assets/svgs/damsel.svg"`
  - `"~/characters/boss.svg"`
  - `"/path/to/guide.svg"`

## Complete Level Examples

### Basic Level

Simple level with minimal configuration:

```json
{
  "name": "level_1",
  "collectibles": 4,
  "target_score": 40,
  "background_color": "#1a1a1a",
  "layout": "grid"
}
```

### Level with NPC

Level with custom NPC message:

```json
{
  "name": "level_2",
  "collectibles": 6,
  "target_score": 60,
  "background_color": "#2a1a2a",
  "layout": "horizontal",
  "npc": {
    "enabled": true,
    "type": "warrior",
    "message": "Brave the horizontal platforms!",
    "svg": ""
  }
}
```

### Level with Custom NPC Sprite

Level with unique NPC appearance:

```json
{
  "name": "boss_level",
  "collectibles": 10,
  "target_score": 100,
  "background_color": "#3a1a1a",
  "layout": "random",
  "npc": {
    "enabled": true,
    "type": "boss",
    "message": "Face the final challenge!",
    "svg": "./assets/svgs/boss.svg"
  }
}
```

### Celebration Level

Victory screen that auto-wins:

```json
{
  "name": "celebration",
  "celebration_level": true,
  "auto_win_delay": 5,
  "collectibles": 0,
  "target_score": 0,
  "background_color": "#1a3a1a",
  "layout": "grid",
  "npc": {
    "enabled": true,
    "type": "victory",
    "message": "Congratulations! You've completed all levels!",
    "svg": "./assets/svgs/victory_character.svg"
  }
}
```

### Level without NPC

Level with no NPC:

```json
{
  "name": "solo_challenge",
  "collectibles": 8,
  "target_score": 80,
  "background_color": "#1a1a3a",
  "layout": "diagonal",
  "npc": {
    "enabled": false
  }
}
```

## Multi-Level Campaign Examples

### 3-Level Progressive Campaign

**my_levels.json:**
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
        "message": "Welcome! Collect 40 points!"
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
        "message": "Level 2 - Reach 60 points!"
      }
    },
    {
      "name": "level_3",
      "collectibles": 8,
      "target_score": 80,
      "background_color": "#3a1a1a",
      "layout": "random",
      "npc": {
        "enabled": true,
        "message": "Final level - Get 80 points!"
      }
    }
  ]
}
```

### Campaign with Celebration Ending

**adventure_levels.json:**
```json
{
  "levels": [
    {
      "name": "forest",
      "collectibles": 5,
      "target_score": 50,
      "background_color": "#1a3a1a",
      "layout": "grid",
      "npc": {
        "enabled": true,
        "message": "Navigate the forest!",
        "svg": "./assets/forest_guide.svg"
      }
    },
    {
      "name": "cave",
      "collectibles": 7,
      "target_score": 70,
      "background_color": "#1a1a3a",
      "layout": "circle",
      "npc": {
        "enabled": true,
        "message": "Explore the cave depths!",
        "svg": "./assets/cave_dweller.svg"
      }
    },
    {
      "name": "summit",
      "collectibles": 10,
      "target_score": 100,
      "background_color": "#3a3a3a",
      "layout": "vertical",
      "npc": {
        "enabled": true,
        "message": "Climb to the summit!",
        "svg": "./assets/mountain_sage.svg"
      }
    },
    {
      "name": "victory",
      "celebration_level": true,
      "auto_win_delay": 5,
      "collectibles": 0,
      "target_score": 0,
      "background_color": "#2a4a2a",
      "npc": {
        "enabled": true,
        "message": "You are the champion!",
        "svg": "./assets/champion.svg"
      }
    }
  ]
}
```

## Level Progression Flow

### How Levels Connect

1. **Start**: Player selection screen (shown once)
2. **Level 1**: First level loads
3. **Complete**: Reach target score
4. **Transition**: Victory sound → Load next level
5. **Level 2**: Continue with same player
6. **Repeat**: Until all levels complete
7. **Victory**: Final victory message
8. **Restart**: Press key to restart from Level 1

### Player Persistence

- **Character Type**: Maintained across all levels
- **Score**: Resets to 0 at each level start
- **Sprite**: Player sprite persists throughout campaign

## Design Guidelines

### Difficulty Progression

**Easy → Medium → Hard:**

```json
{
  "levels": [
    {
      "name": "easy",
      "collectibles": 4,
      "target_score": 40,
      "layout": "grid"
    },
    {
      "name": "medium",
      "collectibles": 6,
      "target_score": 60,
      "layout": "horizontal"
    },
    {
      "name": "hard",
      "collectibles": 10,
      "target_score": 100,
      "layout": "random"
    }
  ]
}
```

### Visual Variety

Use different background colors for each level:

- **Level 1**: `"#1a1a1a"` (neutral dark gray)
- **Level 2**: `"#2a1a2a"` (purple tint)
- **Level 3**: `"#1a3a1a"` (green tint)
- **Level 4**: `"#3a1a1a"` (red tint)

### Layout Variety

Mix layouts for gameplay variety:

- **Tutorial**: `"grid"` (predictable)
- **Exploration**: `"scatter"` (wide distribution)
- **Challenge**: `"random"` (unpredictable)
- **Finale**: `"circle"` (pattern-based)

### Target Score Guidelines

**Formula**: `collectibles × 10 = target_score`

This ensures collecting all items wins the level.

**Variations**:
- **Easy**: Lower score (e.g., 30 for 4 collectibles)
- **Hard**: Higher score (e.g., 60 for 4 collectibles, need repeats)

## Platform Layout

Each level automatically generates platforms:

- **Ground**: Full-width grass platform at bottom
- **Jump Platforms**: 6-8 platforms at varying heights
- **Spacing**: 400 pixels apart horizontally
- **Heights**: Alternating 250px, 350px, 450px above ground

Collectibles are placed 100 pixels above platforms based on the selected layout pattern.

## Troubleshooting

### Level not loading

**Issue**: Level scene not found

**Check**:
- Level `name` matches scene file
- Number of levels in JSON matches `level_count`
- JSON syntax is valid

### Wrong collectible count

**Issue**: More/fewer collectibles than configured

**Check**:
- `collectibles` value in JSON
- JSON file path in `levels_config`
- Post-generation hook completed successfully

### NPC not showing

**Issue**: NPC missing from level

**Check**:
- `npc.enabled` is `true`
- `include_npc` is `"yes"` in cookiecutter config
- Scene generation completed successfully

### Custom NPC sprite not loading

**Issue**: Default sprite shown instead of custom

**Check**:
- SVG file path is correct
- File exists at specified path
- Path uses correct format (absolute, relative, or `~`)

## Next Steps

- [Collectible Layouts](layouts.md) - Learn about layout patterns
- [Configuration Guide](configuration.md) - See all configuration options
- [Examples](examples.md) - View complete examples
- [Customization](customization.md) - Modify level properties

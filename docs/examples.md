# Configuration Examples

Complete examples for different game types and configurations.

## Quick Examples

### Minimal Setup

Generate with all defaults:

```bash
cookiecutter .
```

Press Enter for each prompt to accept defaults. Creates a single-level game with blue/red/green players.

### Simple Command-Line

Override just a few parameters:

```bash
cookiecutter . project_name="My Game" level_count="3"
```

Creates a 3-level game with auto-generated levels.

## Single-Level Games

### Basic Platformer

Default endless mode:

```bash
cookiecutter . \
  project_name="Simple Platformer" \
  project_slug="simple_platformer"
```

**Result**:
- Endless mode
- Target score: 100
- Blue/red/green player types
- NPC enabled
- 1 level

### Timed Challenge

30-second speed run:

```bash
cookiecutter . \
  project_name="Speed Runner" \
  project_slug="speed_runner" \
  game_mode="timed" \
  time_limit="30" \
  target_score="50" \
  include_npc="no"
```

**Result**:
- Timed mode (30 seconds)
- Target score: 50
- No NPC distractions
- Fast-paced gameplay

### Score Target Game

Pure collection focus:

```bash
cookiecutter . \
  project_name="Gem Collector" \
  project_slug="gem_collector" \
  game_mode="score_target" \
  target_score="200"
```

**Result**:
- Score target mode
- High target score (200)
- Relaxed gameplay
- No time pressure

## Multi-Level Games

### 3-Level Adventure

Auto-generated levels:

```bash
cookiecutter . \
  project_name="Platform Adventure" \
  project_slug="platform_adventure" \
  level_count="3"
```

**Result**:
- Level 1: 4 collectibles, target 40
- Level 2: 6 collectibles, target 60
- Level 3: 8 collectibles, target 80
- Auto-increasing difficulty

### Custom Level Campaign

**Command:**
```bash
cookiecutter . \
  project_name="Custom Adventure" \
  project_slug="custom_adventure" \
  level_count="3" \
  levels_config="./adventure_levels.json"
```

**adventure_levels.json:**
```json
{
  "levels": [
    {
      "name": "tutorial",
      "collectibles": 3,
      "target_score": 30,
      "background_color": "#1a1a1a",
      "layout": "grid",
      "npc": {
        "enabled": true,
        "message": "Welcome! Learn the controls.",
        "svg": ""
      }
    },
    {
      "name": "forest",
      "collectibles": 6,
      "target_score": 60,
      "background_color": "#1a3a1a",
      "layout": "horizontal",
      "npc": {
        "enabled": true,
        "message": "Navigate the forest platforms!",
        "svg": "./assets/forest_guide.svg"
      }
    },
    {
      "name": "boss_level",
      "collectibles": 10,
      "target_score": 100,
      "background_color": "#3a1a1a",
      "layout": "random",
      "npc": {
        "enabled": true,
        "message": "Final challenge!",
        "svg": "./assets/boss.svg"
      }
    }
  ]
}
```

**Result**:
- Custom level names
- Progressive difficulty
- Unique NPC messages
- Varied layouts

## Custom Graphics

### RPG-Style Characters

**Command:**
```bash
cookiecutter . \
  project_name="RPG Adventure" \
  project_slug="rpg_adventure" \
  player_types="warrior,mage,rogue" \
  custom_player_svgs="warrior:~/sprites/warrior.svg,mage:~/sprites/mage.svg,rogue:~/sprites/rogue.svg"
```

**Result**:
- Three distinct character classes
- Unique sprite for each type
- RPG theme

### Single Custom Character

**Command:**
```bash
cookiecutter . \
  project_name="Hero Quest" \
  project_slug="hero_quest" \
  player_types="hero" \
  custom_player_svgs="hero:~/my_hero.svg"
```

**Result**:
- Only one player type
- No selection screen (auto-starts)
- Custom hero sprite

### Custom NPC

Single-level game with custom NPC:

```bash
cookiecutter . \
  project_name="NPC Demo" \
  project_slug="npc_demo" \
  custom_npc_svg="~/characters/guide.svg"
```

**Result**:
- Custom NPC sprite
- Default player types
- Single level

## Config File Examples

### Complete Configuration

**my_game_config.json:**
```json
{
  "default_context": {
    "project_name": "Complete Adventure",
    "project_slug": "complete_adventure",
    "author_name": "Game Studio",
    "godot_version": "4.5",
    "player_types": "warrior,mage,rogue",
    "custom_player_svgs": "warrior:./sprites/warrior.svg,mage:./sprites/mage.svg,rogue:./sprites/rogue.svg",
    "include_npc": "yes",
    "game_mode": "timed",
    "time_limit": "90",
    "target_score": "150",
    "victory_sound": "./audio/victory.wav",
    "level_count": "4",
    "levels_config": "./complete_levels.json"
  }
}
```

**complete_levels.json:**
```json
{
  "levels": [
    {
      "name": "plains",
      "collectibles": 5,
      "target_score": 50,
      "background_color": "#2a3a2a",
      "layout": "grid",
      "npc": {
        "enabled": true,
        "message": "Welcome to the plains!",
        "svg": "./assets/plains_npc.svg"
      }
    },
    {
      "name": "forest",
      "collectibles": 7,
      "target_score": 70,
      "background_color": "#1a3a1a",
      "layout": "horizontal",
      "npc": {
        "enabled": true,
        "message": "Cross the forest platforms!",
        "svg": "./assets/forest_npc.svg"
      }
    },
    {
      "name": "mountain",
      "collectibles": 10,
      "target_score": 100,
      "background_color": "#3a3a4a",
      "layout": "vertical",
      "npc": {
        "enabled": true,
        "message": "Climb to the summit!",
        "svg": "./assets/mountain_npc.svg"
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
        "message": "Congratulations, hero!",
        "svg": "./assets/king.svg"
      }
    }
  ]
}
```

**Usage:**
```bash
cookiecutter . --no-input --config-file my_game_config.json
```

**Result**:
- 4 levels with unique themes
- Timed mode (90 seconds)
- Custom sprites for each player type
- Unique NPC per level
- Celebration ending
- Custom victory sound

### Minimal Config with Levels

**quick_config.json:**
```json
{
  "default_context": {
    "project_name": "Quick Game",
    "project_slug": "quick_game",
    "level_count": "2",
    "levels_config": "./quick_levels.json"
  }
}
```

**quick_levels.json:**
```json
{
  "levels": [
    {
      "name": "level_1",
      "collectibles": 4,
      "target_score": 40,
      "background_color": "#1a1a1a",
      "layout": "grid"
    },
    {
      "name": "level_2",
      "collectibles": 6,
      "target_score": 60,
      "background_color": "#2a1a2a",
      "layout": "horizontal"
    }
  ]
}
```

**Result**:
- 2 simple levels
- All other settings use defaults
- No custom graphics
- Endless mode

## Theme Examples

### Educational Game

Kid-friendly endless mode:

**kid_game_config.json:**
```json
{
  "default_context": {
    "project_name": "Learning Adventure",
    "project_slug": "learning_adventure",
    "player_types": "student",
    "custom_player_svgs": "student:./kid_sprite.svg",
    "game_mode": "endless",
    "target_score": "50",
    "include_npc": "yes",
    "level_count": "3",
    "levels_config": "./edu_levels.json"
  }
}
```

**edu_levels.json:**
```json
{
  "levels": [
    {
      "name": "numbers",
      "collectibles": 5,
      "target_score": 50,
      "background_color": "#1a3a4a",
      "layout": "grid",
      "npc": {
        "enabled": true,
        "message": "Collect all the numbers!",
        "svg": ""
      }
    },
    {
      "name": "letters",
      "collectibles": 5,
      "target_score": 50,
      "background_color": "#3a1a4a",
      "layout": "circle",
      "npc": {
        "enabled": true,
        "message": "Find all the letters!",
        "svg": ""
      }
    },
    {
      "name": "shapes",
      "collectibles": 5,
      "target_score": 50,
      "background_color": "#3a3a1a",
      "layout": "scatter",
      "npc": {
        "enabled": true,
        "message": "Great job!",
        "svg": ""
      }
    }
  ]
}
```

### Boss Rush Game

Multiple boss encounters:

**boss_config.json:**
```json
{
  "default_context": {
    "project_name": "Boss Rush",
    "project_slug": "boss_rush",
    "player_types": "knight",
    "game_mode": "timed",
    "time_limit": "120",
    "level_count": "3",
    "levels_config": "./boss_levels.json"
  }
}
```

**boss_levels.json:**
```json
{
  "levels": [
    {
      "name": "goblin_king",
      "collectibles": 8,
      "target_score": 80,
      "background_color": "#2a1a1a",
      "layout": "random",
      "npc": {
        "enabled": true,
        "message": "Face the Goblin King!",
        "svg": "./bosses/goblin.svg"
      }
    },
    {
      "name": "dragon",
      "collectibles": 12,
      "target_score": 120,
      "background_color": "#3a1a1a",
      "layout": "scatter",
      "npc": {
        "enabled": true,
        "message": "Defeat the Dragon!",
        "svg": "./bosses/dragon.svg"
      }
    },
    {
      "name": "dark_lord",
      "collectibles": 15,
      "target_score": 150,
      "background_color": "#1a1a3a",
      "layout": "circle",
      "npc": {
        "enabled": true,
        "message": "Final boss!",
        "svg": "./bosses/dark_lord.svg"
      }
    }
  ]
}
```

### Exploration Game

Relaxed collection focus:

```bash
cookiecutter . \
  project_name="Treasure Hunter" \
  project_slug="treasure_hunter" \
  game_mode="score_target" \
  target_score="300" \
  level_count="5" \
  levels_config="./exploration_levels.json"
```

**exploration_levels.json:**
```json
{
  "levels": [
    {
      "name": "beach",
      "collectibles": 6,
      "target_score": 60,
      "background_color": "#2a3a4a",
      "layout": "scatter",
      "npc": { "enabled": true, "message": "Search the beach!" }
    },
    {
      "name": "jungle",
      "collectibles": 8,
      "target_score": 80,
      "background_color": "#1a3a1a",
      "layout": "random",
      "npc": { "enabled": true, "message": "Explore the jungle!" }
    },
    {
      "name": "cave",
      "collectibles": 10,
      "target_score": 100,
      "background_color": "#1a1a2a",
      "layout": "scatter",
      "npc": { "enabled": true, "message": "Delve into the cave!" }
    },
    {
      "name": "ruins",
      "collectibles": 12,
      "target_score": 120,
      "background_color": "#2a2a1a",
      "layout": "random",
      "npc": { "enabled": true, "message": "Discover ancient ruins!" }
    },
    {
      "name": "treasure_room",
      "collectibles": 15,
      "target_score": 150,
      "background_color": "#3a3a1a",
      "layout": "circle",
      "npc": { "enabled": true, "message": "The treasure awaits!" }
    }
  ]
}
```

## Layout Examples

### Demonstrating All Layouts

Showcase all 8 layout patterns:

**layouts_demo_levels.json:**
```json
{
  "levels": [
    { "name": "grid_demo", "collectibles": 6, "target_score": 60, "background_color": "#1a1a1a", "layout": "grid" },
    { "name": "circle_demo", "collectibles": 6, "target_score": 60, "background_color": "#1a1a2a", "layout": "circle" },
    { "name": "horizontal_demo", "collectibles": 6, "target_score": 60, "background_color": "#1a2a1a", "layout": "horizontal" },
    { "name": "vertical_demo", "collectibles": 6, "target_score": 60, "background_color": "#2a1a1a", "layout": "vertical" },
    { "name": "diagonal_demo", "collectibles": 6, "target_score": 60, "background_color": "#2a2a1a", "layout": "diagonal" },
    { "name": "corners_demo", "collectibles": 6, "target_score": 60, "background_color": "#1a2a2a", "layout": "corners" },
    { "name": "random_demo", "collectibles": 6, "target_score": 60, "background_color": "#2a1a2a", "layout": "random" },
    { "name": "scatter_demo", "collectibles": 6, "target_score": 60, "background_color": "#3a3a3a", "layout": "scatter" }
  ]
}
```

**Usage:**
```bash
cookiecutter . \
  project_name="Layout Demo" \
  project_slug="layout_demo" \
  level_count="8" \
  levels_config="./layouts_demo_levels.json"
```

## Celebration Level Examples

### Victory Lap

Final celebration after challenges:

```json
{
  "levels": [
    {
      "name": "level_1",
      "collectibles": 5,
      "target_score": 50,
      "background_color": "#1a1a1a",
      "layout": "grid"
    },
    {
      "name": "level_2",
      "collectibles": 8,
      "target_score": 80,
      "background_color": "#2a1a2a",
      "layout": "random"
    },
    {
      "name": "victory_celebration",
      "celebration_level": true,
      "auto_win_delay": 3,
      "collectibles": 0,
      "target_score": 0,
      "background_color": "#1a3a1a",
      "npc": {
        "enabled": true,
        "message": "You are victorious!",
        "svg": "./victory_npc.svg"
      }
    }
  ]
}
```

## Testing Configurations

### Debug Mode

Quick iteration testing:

```bash
cookiecutter . \
  project_name="Test" \
  project_slug="test" \
  level_count="2" \
  target_score="20"
```

Low target score for quick testing.

### Performance Test

Many collectibles:

```json
{
  "levels": [
    {
      "name": "stress_test",
      "collectibles": 20,
      "target_score": 200,
      "background_color": "#1a1a1a",
      "layout": "random"
    }
  ]
}
```

## Next Steps

- [Configuration Guide](configuration.md) - Parameter reference
- [Level Configuration](levels.md) - Level property details
- [Quick Start](quick-start.md) - Generate your first game
- [Customization](customization.md) - Modify generated games

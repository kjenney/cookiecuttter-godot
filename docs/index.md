# Godot 4 2D Platformer Builder

A CookieCutter template for creating side-scrolling 2D platformer games in Godot 4 that uses CookieCutter configuration to guide how the game is built.

## Overview

This template provides a complete foundation for building 2D platformer games with:

- **Platformer Physics**: Gravity, jumping, and smooth horizontal movement
- **Side-Scrolling Levels**: Camera follows the player through horizontally scrolling levels
- **Configurable Levels**: JSON-based configuration for creating multiple levels with different layouts
- **Sprite Animations**: Animated characters with idle, running, and collecting animations
- **Multiple Game Modes**: Timed, endless, or score target gameplay
- **Collectible System**: Items placed strategically on platforms
- **NPC Interactions**: Optional NPCs with speech bubbles

## Key Features

### Player System
- **Player Selection**: Choose between different character types at game start
- **Platformer Physics**: Realistic gravity (980 px/s²) and jump mechanics (700 px/s velocity)
- **Sprite Animations**: Automatic animation switching (idle/running/collecting)
- **Sprite Flipping**: Character faces the direction of movement

### Level Design
- **Platforms & Ground**: Automatically generated grass-style ground with jump platforms
- **8 Layout Patterns**: Grid, circle, horizontal, vertical, diagonal, corners, random, scatter
- **Camera Follow**: Smooth camera tracking with look-ahead offset
- **Multiple Levels**: Progressive difficulty with level-to-level persistence

### Customization
- **Custom Player Sprites**: Use your own SVG graphics for different character types
- **Custom NPC Sprites**: Level-specific NPC appearances and messages
- **Custom Sounds**: Replace victory sound with your own audio
- **Configurable Physics**: Adjust gravity, jump height, and movement speed

### Game Modes
- **Endless Mode**: Play at your own pace to reach the target score
- **Timed Mode**: Race against the clock to complete levels
- **Score Target Mode**: Focus solely on collecting items
- **Celebration Levels**: Auto-win victory screens after completing challenges

## Quick Links

- [Installation Guide](installation.md) - Get started with prerequisites and setup
- [Configuration](configuration.md) - Learn about configuration options
- [Level Configuration](levels.md) - Create custom levels with unique layouts
- [Controls](controls.md) - Player controls and input mapping
- [Examples](examples.md) - Example configurations to get started quickly

## Project Philosophy

This template prioritizes:

1. **Easy Configuration**: JSON-based level design without coding
2. **Extensibility**: Clean code structure for adding features
3. **Visual Customization**: SVG support for custom graphics
4. **Rapid Prototyping**: Generate playable games in minutes

## What's Included

When you generate a project, you'll get:

- Complete Godot 4 project structure
- Player, NPC, and collectible scenes
- Game manager with scoring and level transitions
- UI layer with score tracking
- Multiple pre-configured levels
- Platform generation system
- Animation framework
- Unit test setup with GUT
- Custom player and NPC graphics (if provided)

## Next Steps

1. **[Install Prerequisites](installation.md)** - Set up Godot 4 and Cookiecutter
2. **[Generate Your First Game](quick-start.md)** - Create a game in 5 minutes
3. **[Configure Levels](levels.md)** - Customize your game's levels and difficulty
4. **[Add Custom Graphics](customization.md)** - Make it uniquely yours

## License

This template is provided as-is for educational and commercial use.

## Contributing

Feel free to fork and customize this template for your own needs!

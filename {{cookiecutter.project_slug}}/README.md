# {{cookiecutter.project_name}}

A simple 2D collectible game built with Godot 4.

**Author**: {{cookiecutter.author_name}}

## About

This is a basic 2D game where you control a character that moves around collecting objects. It was created from a Godot 4 CookieCutter template.

## How to Play

1. Open this project in Godot {{cookiecutter.godot_version}} or later
2. Press F5 or click the Play button
3. Use WASD or Arrow keys to move your character
4. Collect the golden objects scattered around the level
5. Watch your score increase in the console output

## Project Structure

- `scenes/` - Contains all scene files (.tscn)
  - `player.tscn` - The player character
  - `collectible.tscn` - Collectible objects
  - `main.tscn` - Main game scene
- `scripts/` - Contains all GDScript files (.gd)
  - `player.gd` - Player movement logic
  - `collectible.gd` - Collectible behavior
  - `game_manager.gd` - Game state and score tracking
- `assets/` - Place your game assets here (sprites, sounds, etc.)

## Next Steps

Here are some ideas to expand this game:

1. **Add Custom Graphics**: Replace the placeholder icon with custom sprites
2. **Create a UI**: Add an on-screen score display using a Label in a CanvasLayer
3. **Add Sound Effects**: Import audio files and play them when collecting objects
4. **Create More Levels**: Design new scenes with different layouts
5. **Add Obstacles**: Create walls or barriers using StaticBody2D
6. **Implement Enemies**: Add moving enemies that the player must avoid
7. **Add Power-ups**: Create special collectibles with unique effects

## Controls

- **Arrow Keys** or **WASD**: Move the player

## License

Add your license information here.

---

Happy game development!

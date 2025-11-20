# Quick Start Guide

## Testing the Template

To test this CookieCutter template locally:

```bash
# Make sure cookiecutter is installed
pip install cookiecutter

# Create a new project from the template
cookiecutter /Users/kjenney/devel/godot/godot_antigravity

# Or use the current directory
cookiecutter .
```

## Example Usage

When you run cookiecutter, you'll see prompts like:

```
project_name [My Godot Game]: Space Collector
project_slug [space_collector]: 
author_name [Your Name]: John Doe
godot_version [4.0]: 4.2
```

This will create a new directory `space_collector/` with your game ready to open in Godot!

## Opening in Godot

1. Launch Godot 4
2. Click "Import"
3. Navigate to your generated project folder
4. Select the `project.godot` file
5. Click "Import & Edit"
6. Press F5 to run the game

## What You Get

- A player character (blue icon) that moves with WASD/Arrow keys
- Four collectible objects (golden icons) placed around the scene
- Score tracking (printed to console when you collect objects)
- A dark background for contrast
- Clean, organized code structure

## Customization

All the code is simple and well-commented. Start by:
1. Replacing `icon.svg` with your own sprites
2. Modifying the player speed in `scripts/player.gd`
3. Changing collectible point values in `scripts/collectible.gd`
4. Adding more collectibles in `scenes/main.tscn`

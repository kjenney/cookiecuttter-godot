# Testing Guide

Guide to testing your platformer game using GUT (Godot Unit Test).

## Overview

The template includes a testing framework using [GUT (Godot Unit Test)](https://github.com/bitwes/Gut), a popular unit testing framework for Godot.

## Installation

### 1. Install GUT

**Option A: AssetLib (Easiest)**

1. Open Godot Editor
2. Click **AssetLib** tab (top center)
3. Search for "GUT"
4. Click **Gut** by bitwes
5. Click **Download** → **Install**
6. Accept default installation path

**Option B: Manual Download**

1. Visit [GUT GitHub Releases](https://github.com/bitwes/Gut/releases)
2. Download latest release ZIP
3. Extract to `addons/gut/` in your project
4. Ensure path is `res://addons/gut/gut.gd`

### 2. Enable Plugin

1. Open **Project → Project Settings**
2. Click **Plugins** tab
3. Check **Enable** next to "Gut"
4. Restart Godot if prompted

### 3. Verify Installation

Check for GUT panel at bottom of editor:
- Look for **GUT** tab next to Output, Debugger, etc.
- If present, installation successful

## Running Tests

### Using GUT Panel

1. Click **GUT** tab in bottom panel
2. Click **gear icon** (settings) on right
3. Under **Directories**, add: `res://tests`
4. Check **Include Subdirs** if you have subdirectories
5. Click **Run All** button

**Result**: Tests execute and results appear in panel.

### Command Line

Run tests without opening editor:

```bash
godot --headless -s addons/gut/gut_cmdln.gd
```

**Options:**
```bash
# Run specific test file
godot --headless -s addons/gut/gut_cmdln.gd -gtest=res://tests/test_player.gd

# Run with detailed output
godot --headless -s addons/gut/gut_cmdln.gd -gverbose

# Run and exit
godot --headless -s addons/gut/gut_cmdln.gd -gexit
```

### Configuration File

The template includes `.gutconfig.json`:

```json
{
  "dirs": ["res://tests/"],
  "include_subdirs": true,
  "log_level": 1,
  "should_exit": true,
  "should_maximize": false
}
```

Run with config:
```bash
godot --headless -s addons/gut/gut_cmdln.gd
```

## Test Structure

### Test File Naming

GUT auto-discovers test files:

- **Pattern**: `test_*.gd` or `*_test.gd`
- **Location**: `res://tests/` directory
- **Examples**:
  - `test_player.gd`
  - `test_game_manager.gd`
  - `player_test.gd`

### Test Class Structure

```gdscript
extends GutTest

# Run once before all tests
func before_all():
    pass

# Run before each test
func before_each():
    pass

# Test methods (must start with test_)
func test_something():
    assert_true(true, "This test passes")

# Run after each test
func after_each():
    pass

# Run once after all tests
func after_all():
    pass
```

## Example Tests

### Test Player Movement

**tests/test_player.gd:**

```gdscript
extends GutTest

var player_scene = preload("res://scenes/player.tscn")
var player

func before_each():
    player = player_scene.instantiate()
    add_child_autofree(player)

func test_player_has_correct_speed():
    assert_eq(player.speed, 300.0, "Default speed should be 300")

func test_player_has_correct_jump_velocity():
    assert_eq(player.jump_velocity, -700.0, "Default jump velocity should be -700")

func test_player_has_correct_gravity():
    assert_eq(player.gravity, 980.0, "Default gravity should be 980")

func test_player_has_animated_sprite():
    var sprite = player.get_node_or_null("AnimatedSprite2D")
    assert_not_null(sprite, "Player should have AnimatedSprite2D")

func test_player_physics_enabled():
    assert_true(player is CharacterBody2D, "Player should be CharacterBody2D")
```

### Test Collectible

**tests/test_collectible.gd:**

```gdscript
extends GutTest

var collectible_scene = preload("res://scenes/collectible.tscn")
var collectible

func before_each():
    collectible = collectible_scene.instantiate()
    add_child_autofree(collectible)

func test_collectible_is_area2d():
    assert_true(collectible is Area2D, "Collectible should be Area2D")

func test_collectible_has_collision_shape():
    var shape = collectible.get_node_or_null("CollisionShape2D")
    assert_not_null(shape, "Collectible should have CollisionShape2D")

func test_collectible_has_visual():
    var visual = collectible.get_node_or_null("ColorRect")
    assert_not_null(visual, "Collectible should have ColorRect")

func test_collectible_collision_layers():
    assert_eq(collectible.collision_layer, 8, "Collectible should be on layer 4 (8)")
    assert_eq(collectible.collision_mask, 2, "Collectible should detect layer 2")
```

### Test Game Manager

**tests/test_game_manager.gd:**

```gdscript
extends GutTest

var game_manager_script = preload("res://scripts/game_manager.gd")
var game_manager

func before_each():
    game_manager = Node.new()
    game_manager.set_script(game_manager_script)
    add_child_autofree(game_manager)

func test_initial_score_is_zero():
    assert_eq(game_manager.score, 0, "Initial score should be 0")

func test_add_score():
    game_manager.add_score(10)
    assert_eq(game_manager.score, 10, "Score should be 10 after adding 10")

func test_add_score_multiple_times():
    game_manager.add_score(10)
    game_manager.add_score(20)
    game_manager.add_score(30)
    assert_eq(game_manager.score, 60, "Score should be 60 after adding 10+20+30")

func test_target_score():
    assert_gt(game_manager.target_score, 0, "Target score should be greater than 0")
```

### Test Physics

**tests/test_player_physics.gd:**

```gdscript
extends GutTest

var player_scene = preload("res://scenes/player.tscn")
var player

func before_each():
    player = player_scene.instantiate()
    add_child_autofree(player)

func test_player_falls_with_gravity():
    var initial_y = player.position.y
    # Simulate physics for 1 second
    for i in range(60):  # 60 frames at 60fps
        player._physics_process(1.0/60.0)
    assert_gt(player.position.y, initial_y, "Player should fall due to gravity")

func test_jump_applies_upward_velocity():
    player.velocity.y = 0
    # Simulate jump
    Input.action_press("ui_accept")
    player._physics_process(1.0/60.0)
    Input.action_release("ui_accept")
    assert_lt(player.velocity.y, 0, "Jump should apply upward (negative) velocity")
```

## GUT Assertions

### Common Assertions

```gdscript
# Equality
assert_eq(value, expected, "Message")
assert_ne(value, not_expected, "Message")

# Truthiness
assert_true(condition, "Message")
assert_false(condition, "Message")

# Null checks
assert_null(value, "Message")
assert_not_null(value, "Message")

# Numeric comparisons
assert_gt(value, threshold, "Message")  # Greater than
assert_lt(value, threshold, "Message")  # Less than
assert_ge(value, threshold, "Message")  # Greater or equal
assert_le(value, threshold, "Message")  # Less or equal

# Approximate equality (floats)
assert_almost_eq(value, expected, delta, "Message")

# Type checks
assert_typeof(value, TYPE_INT, "Message")

# Array/Object
assert_has(array, item, "Message")
assert_does_not_have(array, item, "Message")
```

### Advanced Assertions

```gdscript
# File existence
assert_file_exists("res://scenes/player.tscn")
assert_file_does_not_exist("res://deleted.tscn")

# Signal watching
watch_signals(object)
assert_signal_emitted(object, "signal_name")
assert_signal_not_emitted(object, "signal_name")
assert_signal_emitted_with_parameters(object, "signal_name", [param1, param2])

# Call counting
var double = double(MyClass)
double.my_method()
assert_called(double, "my_method")
assert_call_count(double, "my_method", 1)
```

## Test Helpers

### Auto-Free Resources

```gdscript
# Automatically free node after test
func test_something():
    var node = Node.new()
    add_child_autofree(node)
    # node is automatically freed after test
```

### Doubles and Mocks

```gdscript
# Create test double
var double = double(MyClass)

# Stub method to return value
stub(double, "get_score").to_return(100)

# Partial double (only override some methods)
var partial = partial_double(MyClass)
```

### Simulate Input

```gdscript
func test_jump_input():
    Input.action_press("ui_accept")
    player._physics_process(1.0/60.0)
    Input.action_release("ui_accept")
    assert_lt(player.velocity.y, 0)
```

## Best Practices

### Test Organization

```
tests/
├── unit/
│   ├── test_player.gd
│   ├── test_collectible.gd
│   └── test_game_manager.gd
├── integration/
│   ├── test_level_progression.gd
│   └── test_score_system.gd
└── .gutconfig.json
```

### Naming Conventions

- **Test files**: `test_<feature>.gd`
- **Test methods**: `test_<specific_behavior>()`
- **Descriptive**: `test_player_jumps_when_space_pressed()`

### Test Independence

```gdscript
# BAD: Tests depend on each other
var shared_player

func test_1():
    shared_player = player_scene.instantiate()

func test_2():
    shared_player.jump()  # Fails if test_1 doesn't run

# GOOD: Each test is independent
func test_1():
    var player = player_scene.instantiate()
    add_child_autofree(player)

func test_2():
    var player = player_scene.instantiate()
    add_child_autofree(player)
    player.jump()
```

### Clear Assertions

```gdscript
# BAD: No message
assert_eq(player.speed, 300.0)

# GOOD: Clear message
assert_eq(player.speed, 300.0, "Player speed should be 300.0")
```

## Integration Testing

### Test Level Loading

```gdscript
extends GutTest

func test_level_1_loads():
    var level = load("res://scenes/level_1.tscn").instantiate()
    add_child_autofree(level)
    assert_not_null(level, "Level 1 should load")

func test_level_has_player():
    var level = load("res://scenes/level_1.tscn").instantiate()
    add_child_autofree(level)
    var player = level.get_node_or_null("Player")
    assert_not_null(player, "Level should have Player node")

func test_level_has_platforms():
    var level = load("res://scenes/level_1.tscn").instantiate()
    add_child_autofree(level)
    var platforms = level.get_tree().get_nodes_in_group("platforms")
    assert_gt(platforms.size(), 0, "Level should have platforms")
```

## Continuous Integration

### GitHub Actions

**.github/workflows/test.yml:**

```yaml
name: Run Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Download Godot
        run: |
          wget https://downloads.tuxfamily.org/godotengine/4.5/Godot_v4.5-stable_linux.x86_64.zip
          unzip Godot_v4.5-stable_linux.x86_64.zip
          chmod +x Godot_v4.5-stable_linux.x86_64
      
      - name: Run GUT Tests
        run: |
          ./Godot_v4.5-stable_linux.x86_64 --headless -s addons/gut/gut_cmdln.gd
```

## Debugging Tests

### Print Debugging

```gdscript
func test_something():
    print("Value: ", value)
    gut.p("GUT print: " + str(value))
    assert_eq(value, expected)
```

### Run Single Test

In GUT panel:
1. Click test file in list
2. Click individual test method
3. Click **Run** button

Or command line:
```bash
godot --headless -s addons/gut/gut_cmdln.gd -gtest=res://tests/test_player.gd:test_jump
```

### Pause on Failure

In `.gutconfig.json`:
```json
{
  "should_exit_on_success": true,
  "should_exit": false
}
```

## Common Issues

### Tests Not Running

**Check**:
- GUT plugin enabled
- Test files in `res://tests/`
- Test files named `test_*.gd`
- Test methods named `test_*`
- Test class extends `GutTest`

### Scene Loading Errors

**Solution**:
```gdscript
# Use preload for test resources
var scene = preload("res://scenes/player.tscn")

# Check scene loaded
func test_scene_loads():
    assert_not_null(scene, "Scene should load")
```

### Input Not Working

**Solution**:
```gdscript
# Simulate input in test
Input.action_press("ui_accept")
await get_tree().process_frame  # Let input process
player._physics_process(delta)
Input.action_release("ui_accept")
```

## Next Steps

- [GUT Documentation](https://gut.readthedocs.io/) - Official GUT docs
- [GUT GitHub](https://github.com/bitwes/Gut) - Source and examples
- [Customization Guide](customization.md) - Modify game features
- [Project Structure](structure.md) - Understand codebase

# Unit Tests for {{ cookiecutter.project_name }}

This directory contains unit tests for the game functionality using the **GUT (Godot Unit Test)** framework.

## Setup

### Installing GUT

1. **Via Godot Asset Library** (Recommended):
   - Open your project in Godot
   - Go to `AssetLib` tab
   - Search for "GUT"
   - Download and install "Gut - Godot Unit Testing"

2. **Manual Installation**:
   - Download GUT from: https://github.com/bitwes/Gut
   - Extract to `addons/gut` in your project

### Configuration

The test configuration is stored in `.gutconfig.json` in the project root. This file specifies:
- Test directory location
- Test file prefix pattern
- Output settings

## Running Tests

### From Godot Editor

1. Open the project in Godot
2. Go to the bottom panel and select the "Gut" tab
3. Click "Run All" to run all tests
4. Or select individual test files to run specific tests

### From Command Line

```bash
# Run all tests
godot --headless -s addons/gut/gut_cmdln.gd

# Run specific test file
godot --headless -s addons/gut/gut_cmdln.gd -gtest=res://tests/test_player.gd

# Run with more verbose output
godot --headless -s addons/gut/gut_cmdln.gd -glog=2
```

## Test Files

- **test_player.gd** - Tests for player movement, player type selection, and color modulation
- **test_collectible.gd** - Tests for collectible collision detection and score addition
- **test_game_manager.gd** - Tests for game state management and score tracking
- **test_player_select.gd** - Tests for player selection UI and signal emission

## Writing New Tests

To create a new test file:

1. Create a new `.gd` file in the `tests/` directory with the prefix `test_`
2. Extend `GutTest`:
   ```gdscript
   extends GutTest
   ```

3. Use `before_each()` and `after_each()` for setup and teardown:
   ```gdscript
   func before_each():
       # Setup code
       pass
   
   func after_each():
       # Cleanup code
       pass
   ```

4. Write test functions starting with `test_`:
   ```gdscript
   func test_something():
       assert_eq(actual, expected, "Description of what should happen")
   ```

## Common Assertions

- `assert_eq(got, expected, message)` - Assert equality
- `assert_ne(got, not_expected, message)` - Assert inequality
- `assert_true(condition, message)` - Assert true
- `assert_false(condition, message)` - Assert false
- `assert_null(value, message)` - Assert null
- `assert_not_null(value, message)` - Assert not null
- `assert_gt(got, expected, message)` - Assert greater than
- `assert_lt(got, expected, message)` - Assert less than
- `assert_has(object, property, message)` - Assert object has property/method
- `assert_signal_emitted(object, signal_name, message)` - Assert signal was emitted

## Best Practices

1. **Isolation**: Each test should be independent and not rely on other tests
2. **Cleanup**: Use `autoqfree()` or `add_child_autoqfree()` to automatically clean up test objects
3. **Descriptive Names**: Use clear, descriptive test function names
4. **One Assertion Per Test**: Focus each test on a single behavior
5. **Arrange-Act-Assert**: Structure tests with setup, execution, and verification phases

## Continuous Integration

To run tests in CI/CD pipelines:

```yaml
# Example GitHub Actions workflow
- name: Run Tests
  run: |
    godot --headless -s addons/gut/gut_cmdln.gd --quit-on-finish
```

## Resources

- [GUT Documentation](https://github.com/bitwes/Gut/wiki)
- [GUT Quick Start](https://github.com/bitwes/Gut/wiki/Quick-Start)
- [Godot Testing Best Practices](https://docs.godotengine.org/en/stable/contributing/development/testing.html)

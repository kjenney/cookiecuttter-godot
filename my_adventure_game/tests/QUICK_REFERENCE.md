# GUT Testing Quick Reference

## Running Tests

### In Godot Editor
1. Open Godot
2. Bottom panel → "Gut" tab
3. Click "Run All"

### Command Line
```bash
# All tests
godot --headless -s addons/gut/gut_cmdln.gd

# Specific test
godot --headless -s addons/gut/gut_cmdln.gd -gtest=res://tests/test_player.gd

# Verbose output
godot --headless -s addons/gut/gut_cmdln.gd -glog=2
```

## Common Assertions

```gdscript
# Equality
assert_eq(got, expected, "message")
assert_ne(got, not_expected, "message")

# Boolean
assert_true(condition, "message")
assert_false(condition, "message")

# Null checks
assert_null(value, "message")
assert_not_null(value, "message")

# Comparisons
assert_gt(got, expected, "message")  # greater than
assert_lt(got, expected, "message")  # less than
assert_ge(got, expected, "message")  # greater or equal
assert_le(got, expected, "message")  # less or equal

# Strings
assert_string_contains(text, substring, "message")
assert_string_starts_with(text, prefix, "message")
assert_string_ends_with(text, suffix, "message")

# Objects
assert_has(object, property_or_method, "message")
assert_extends(object, class_or_script, "message")

# Signals
watch_signals(object)
assert_signal_emitted(object, "signal_name", "message")
assert_signal_emitted_with_parameters(object, "signal_name", [param1, param2], "message")
assert_signal_not_emitted(object, "signal_name", "message")

# Arrays
assert_has(array, value, "message")
assert_does_not_have(array, value, "message")
```

## Test Structure

```gdscript
extends GutTest

var my_object = null

func before_each():
    # Setup before each test
    my_object = autoqfree(Node.new())

func after_each():
    # Cleanup after each test
    my_object = null

func test_something():
    # Arrange
    var expected = 42
    
    # Act
    var result = my_object.some_method()
    
    # Assert
    assert_eq(result, expected, "Should return 42")
```

## Memory Management

```gdscript
# Auto-free objects after test
var obj = autoqfree(Node.new())

# Auto-free children
add_child_autoqfree(child_node)

# Auto-free with custom queue
var obj = add_free(Node.new())
```

## Mocking & Stubbing

```gdscript
# Stub a method to return a value
stub(object, "method_name").to_return(return_value)

# Stub to call a different method
stub(object, "method_name").to_call_super()

# Partial doubles (real object with stubbed methods)
var partial = partial_double(MyClass).new()
stub(partial, "method_name").to_return(value)

# Spies (track method calls)
var spy = spy(object, "method_name")
assert_called(spy, "method_name")
assert_called_with_parameters(spy, "method_name", [param1, param2])
```

## Parameterized Tests

```gdscript
func test_multiple_values(params=use_parameters([
    [1, 2, 3],
    [5, 5, 10],
    [10, -5, 5]
])):
    var result = params[0] + params[1]
    assert_eq(result, params[2])
```

## Test Organization

```
tests/
├── test_player.gd          # Player functionality
├── test_collectible.gd     # Collectible items
├── test_game_manager.gd    # Game state management
├── test_player_select.gd   # UI and selection
└── integration/            # Integration tests
    └── test_gameplay.gd
```

## Tips

- **One assertion per test** - Focus on single behavior
- **Descriptive names** - `test_player_moves_right_when_right_key_pressed()`
- **AAA pattern** - Arrange, Act, Assert
- **Use before_each/after_each** - Keep tests isolated
- **autoqfree()** - Prevent memory leaks
- **watch_signals()** - Must call before signal emission

## Debugging Tests

```gdscript
# Print during tests
gut.p("Debug message")

# Pause test execution
gut.pause_before_teardown()

# Skip tests
func test_something():
    pending("Not implemented yet")
```

## CI/CD Integration

```yaml
# GitHub Actions example
- name: Run Godot Tests
  run: |
    godot --headless -s addons/gut/gut_cmdln.gd --quit-on-finish
```

## Resources

- [GUT Wiki](https://github.com/bitwes/Gut/wiki)
- [GUT API Reference](https://github.com/bitwes/Gut/wiki/Asserts-and-Methods)
- [Godot Testing Docs](https://docs.godotengine.org/en/stable/contributing/development/testing.html)

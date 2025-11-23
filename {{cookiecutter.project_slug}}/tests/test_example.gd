extends GutTest

# This is an example test file to demonstrate GUT testing patterns
# You can use this as a template for creating your own tests

# Example 1: Testing a simple function
func test_addition():
	var result = 2 + 2
	assert_eq(result, 4, "2 + 2 should equal 4")

# Example 2: Testing with setup and teardown
var my_node = null

func before_each():
	# This runs before each test
	my_node = autoqfree(Node.new())
	my_node.name = "TestNode"

func after_each():
	# This runs after each test
	# autoqfree() handles cleanup automatically
	my_node = null

func test_node_creation():
	assert_not_null(my_node, "Node should be created")
	assert_eq(my_node.name, "TestNode", "Node should have correct name")

# Example 3: Testing signals
signal test_signal(value)

func test_signal_emission():
	# Watch for signals
	watch_signals(self)
	
	# Emit the signal
	test_signal.emit(42)
	
	# Verify it was emitted
	assert_signal_emitted(self, "test_signal", "Signal should be emitted")
	assert_signal_emitted_with_parameters(self, "test_signal", [42], 
		"Signal should be emitted with correct parameter")

# Example 4: Testing with a mock object
func test_with_mock():
	var mock_player = CharacterBody2D.new()
	mock_player.name = "MockPlayer"
	add_child_autoqfree(mock_player)
	
	assert_eq(mock_player.name, "MockPlayer", "Mock should have correct name")
	assert_true(mock_player.is_inside_tree(), "Mock should be in scene tree")

# Example 5: Testing multiple conditions
func test_multiple_assertions():
	var array = [1, 2, 3, 4, 5]
	
	assert_eq(array.size(), 5, "Array should have 5 elements")
	assert_has(array, 3, "Array should contain 3")
	assert_does_not_have(array, 10, "Array should not contain 10")

# Example 6: Testing with parameters
func test_parameterized(params=use_parameters([
	["blue", Color(0.3, 0.5, 1.0)],
	["red", Color(1.0, 0.3, 0.3)],
	["green", Color(0.3, 1.0, 0.5)]
])):
	var color_name = params[0]
	var expected_color = params[1]
	
	# This test runs 3 times with different parameters
	assert_not_null(expected_color, "Color should exist for " + color_name)

# Example 7: Pending test (not yet implemented)
func test_future_feature():
	pending("This feature is not yet implemented")

# Example 8: Testing with assertions about objects
func test_object_properties():
	var sprite = Sprite2D.new()
	add_child_autoqfree(sprite)
	
	assert_has(sprite, "modulate", "Sprite should have modulate property")
	assert_has(sprite, "set_texture", "Sprite should have set_texture method")
	assert_extends(sprite, Node2D, "Sprite should extend Node2D")

# Example 9: Testing boolean conditions
func test_boolean_conditions():
	var is_ready = true
	var is_paused = false
	
	assert_true(is_ready, "Should be ready")
	assert_false(is_paused, "Should not be paused")

# Example 10: Testing comparisons
func test_comparisons():
	var score = 100
	var min_score = 50
	var max_score = 150
	
	assert_gt(score, min_score, "Score should be greater than minimum")
	assert_lt(score, max_score, "Score should be less than maximum")
	assert_ge(score, 100, "Score should be greater than or equal to 100")
	assert_le(score, 100, "Score should be less than or equal to 100")

# Example 11: Testing strings
func test_string_operations():
	var text = "Hello, Godot!"
	
	assert_string_contains(text, "Godot", "Text should contain 'Godot'")
	assert_string_starts_with(text, "Hello", "Text should start with 'Hello'")
	assert_string_ends_with(text, "!", "Text should end with '!'")

# Example 12: Debugging during tests
func test_with_debug_output():
	# Use gut.p() to print during tests
	gut.p("This is a debug message")
	gut.p("Current test: test_with_debug_output")
	
	var value = 42
	gut.p("Value is: " + str(value))
	
	assert_eq(value, 42, "Value should be 42")

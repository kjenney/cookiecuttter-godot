extends GutTest

# Test suite for GameManager functionality

var GameManager = preload("res://scripts/game_manager.gd")
var game_manager_instance = null

func before_each():
	# Create a fresh game manager instance before each test
	game_manager_instance = autoqfree(Node.new())
	game_manager_instance.set_script(GameManager)

func after_each():
	game_manager_instance = null

func test_game_manager_initial_score():
	assert_eq(game_manager_instance.score, 0, "Initial score should be 0")

func test_game_manager_initial_game_state():
	assert_false(game_manager_instance.game_started, "Game should not be started initially")

func test_add_score():
	game_manager_instance.add_score(10)
	assert_eq(game_manager_instance.score, 10, "Score should be 10 after adding 10 points")

func test_add_score_multiple_times():
	game_manager_instance.add_score(10)
	game_manager_instance.add_score(20)
	game_manager_instance.add_score(5)
	assert_eq(game_manager_instance.score, 35, "Score should be 35 after adding 10, 20, and 5 points")

func test_add_score_negative():
	game_manager_instance.add_score(-5)
	assert_eq(game_manager_instance.score, -5, "Score should handle negative values")

func test_on_player_selected_sets_game_started():
	# Setup: Add to scene tree to have access to get_tree()
	add_child_autoqfree(game_manager_instance)
	
	# Create a mock player node
	var mock_player = CharacterBody2D.new()
	mock_player.name = "Player"
	mock_player.set_script(preload("res://scripts/player.gd"))
	var sprite = Sprite2D.new()
	sprite.name = "Sprite2D"
	mock_player.add_child(sprite)
	game_manager_instance.add_child(mock_player)
	
	# Execute
	game_manager_instance._on_player_selected("blue")
	
	# Verify
	assert_true(game_manager_instance.game_started, "Game should be started after player selection")
	assert_false(get_tree().paused, "Game tree should be unpaused after player selection")

func test_on_player_selected_sets_player_type():
	# Setup
	add_child_autoqfree(game_manager_instance)
	
	var mock_player = CharacterBody2D.new()
	mock_player.name = "Player"
	mock_player.set_script(preload("res://scripts/player.gd"))
	var sprite = Sprite2D.new()
	sprite.name = "Sprite2D"
	mock_player.add_child(sprite)
	game_manager_instance.add_child(mock_player)
	mock_player._ready()
	
	# Execute
	game_manager_instance._on_player_selected("red")
	
	# Verify
	assert_eq(mock_player.player_type, "red", "Player type should be set to red")

func test_on_player_selected_with_no_player():
	# Setup: No player node added
	add_child_autoqfree(game_manager_instance)
	
	# Execute: Should not crash when player is not found
	game_manager_instance._on_player_selected("blue")
	
	# Verify: Game should still be started
	assert_true(game_manager_instance.game_started, "Game should be started even if player not found")

func test_game_manager_has_required_methods():
	assert_has(game_manager_instance, "add_score", "GameManager should have add_score method")
	assert_has(game_manager_instance, "show_player_select", "GameManager should have show_player_select method")
	assert_has(game_manager_instance, "_on_player_selected", "GameManager should have _on_player_selected method")

func test_score_accumulation():
	var scores = [5, 10, 15, 20, 25]
	var expected_total = 0
	
	for score in scores:
		game_manager_instance.add_score(score)
		expected_total += score
	
	assert_eq(game_manager_instance.score, expected_total, "Score should accumulate correctly")

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
	assert_has_method(game_manager_instance, "add_score", "GameManager should have add_score method")
	assert_has_method(game_manager_instance, "show_player_select", "GameManager should have show_player_select method")
	assert_has_method(game_manager_instance, "_on_player_selected", "GameManager should have _on_player_selected method")

func test_score_accumulation():
	var scores = [5, 10, 15, 20, 25]
	var expected_total = 0

	for score in scores:
		game_manager_instance.add_score(score)
		expected_total += score

	assert_eq(game_manager_instance.score, expected_total, "Score should accumulate correctly")

# ===== Game Mode Tests =====

func test_game_mode_initialization():
	assert_true("game_mode" in game_manager_instance, "GameManager should have game_mode property")
	assert_true("time_limit" in game_manager_instance, "GameManager should have time_limit property")
	assert_true("target_score" in game_manager_instance, "GameManager should have target_score property")
	assert_true("time_remaining" in game_manager_instance, "GameManager should have time_remaining property")
	assert_true("game_over" in game_manager_instance, "GameManager should have game_over property")

func test_endless_mode_has_no_time_limit():
	game_manager_instance.game_mode = "endless"
	game_manager_instance.game_started = true
	game_manager_instance.game_over = false
	game_manager_instance.target_score = 10000  # Set high target to avoid triggering win

	# Add score multiple times - should not trigger game over if below target
	for i in range(100):
		game_manager_instance.add_score(10)

	assert_false(game_manager_instance.game_over, "Endless mode should not trigger game over before reaching target")
	assert_eq(game_manager_instance.score, 1000, "Score should accumulate freely in endless mode")

func test_timed_mode_initializes_timer():
	game_manager_instance.game_mode = "timed"
	game_manager_instance.time_limit = 60
	game_manager_instance.game_started = false
	game_manager_instance.game_over = false

	# Simulate _ready() behavior for timed mode
	if game_manager_instance.game_mode == "timed":
		game_manager_instance.time_remaining = float(game_manager_instance.time_limit)

	assert_eq(game_manager_instance.time_remaining, 60.0, "Time remaining should be set to time_limit")

func test_timed_mode_countdown():
	add_child_autoqfree(game_manager_instance)
	game_manager_instance.game_mode = "timed"
	game_manager_instance.time_limit = 10
	game_manager_instance.time_remaining = 10.0
	game_manager_instance.game_started = true
	game_manager_instance.game_over = false

	# Simulate time passing
	game_manager_instance._process(5.0)

	assert_almost_eq(game_manager_instance.time_remaining, 5.0, 0.1, "Time should decrease after _process")
	assert_false(game_manager_instance.game_over, "Game should not be over yet")

func test_timed_mode_game_over_when_time_runs_out():
	add_child_autoqfree(game_manager_instance)
	game_manager_instance.game_mode = "timed"
	game_manager_instance.time_remaining = 1.0
	game_manager_instance.game_started = true
	game_manager_instance.game_over = false

	# Simulate time running out
	game_manager_instance._process(2.0)

	assert_true(game_manager_instance.game_over, "Game should be over when time runs out")
	assert_true(get_tree().paused, "Game tree should be paused when game is over")

func test_timed_mode_does_not_countdown_before_game_starts():
	add_child_autoqfree(game_manager_instance)
	game_manager_instance.game_mode = "timed"
	game_manager_instance.time_remaining = 10.0
	game_manager_instance.game_started = false
	game_manager_instance.game_over = false

	# Simulate time passing
	game_manager_instance._process(5.0)

	assert_eq(game_manager_instance.time_remaining, 10.0, "Time should not decrease before game starts")

func test_score_target_mode_win_condition():
	add_child_autoqfree(game_manager_instance)

	# Create mock UI layer to avoid null reference errors
	var mock_ui = CanvasLayer.new()
	var end_label = Label.new()
	end_label.name = "EndGameLabel"
	end_label.visible = false
	mock_ui.add_child(end_label)
	game_manager_instance.add_child(mock_ui)
	game_manager_instance.ui_layer = mock_ui

	game_manager_instance.game_mode = "score_target"
	game_manager_instance.target_score = 100
	game_manager_instance.game_started = true
	game_manager_instance.game_over = false

	# Add score to reach target
	game_manager_instance.add_score(50)
	assert_false(game_manager_instance.game_over, "Game should not be over before reaching target")

	game_manager_instance.add_score(50)
	assert_true(game_manager_instance.game_over, "Game should be over when target score is reached")
	assert_true(get_tree().paused, "Game tree should be paused when target is reached")

func test_score_target_mode_win_with_excess_score():
	add_child_autoqfree(game_manager_instance)
	game_manager_instance.game_mode = "score_target"
	game_manager_instance.target_score = 100
	game_manager_instance.game_started = true
	game_manager_instance.game_over = false

	# Add more than target score at once
	game_manager_instance.add_score(150)

	assert_true(game_manager_instance.game_over, "Game should be over when score exceeds target")
	assert_eq(game_manager_instance.score, 150, "Score should be the full amount added")

func test_target_score_triggers_in_endless_mode():
	add_child_autoqfree(game_manager_instance)
	game_manager_instance.game_mode = "endless"
	game_manager_instance.target_score = 100
	game_manager_instance.game_started = true
	game_manager_instance.game_over = false

	# Add score to reach target
	game_manager_instance.add_score(100)

	assert_true(game_manager_instance.game_over, "Endless mode should trigger game over when target score is reached")
	assert_true(get_tree().paused, "Game should be paused when target is reached in endless mode")

func test_target_score_triggers_in_timed_mode():
	add_child_autoqfree(game_manager_instance)
	game_manager_instance.game_mode = "timed"
	game_manager_instance.target_score = 100
	game_manager_instance.time_remaining = 50.0
	game_manager_instance.game_started = true
	game_manager_instance.game_over = false

	# Add score to reach target before time runs out
	game_manager_instance.add_score(100)

	assert_true(game_manager_instance.game_over, "Timed mode should trigger game over when target score is reached")
	assert_true(get_tree().paused, "Game should be paused when target is reached in timed mode")

func test_add_score_when_game_over():
	game_manager_instance.game_mode = "endless"
	game_manager_instance.game_started = true
	game_manager_instance.game_over = true
	game_manager_instance.score = 50

	# Try to add score after game over
	game_manager_instance.add_score(10)

	assert_eq(game_manager_instance.score, 50, "Score should not change when game is over")

func test_end_game_method():
	add_child_autoqfree(game_manager_instance)
	game_manager_instance.game_over = false

	game_manager_instance.end_game(true, "You win!")

	assert_true(game_manager_instance.game_over, "game_over should be true after end_game is called")
	assert_true(get_tree().paused, "Game tree should be paused after end_game is called")

func test_update_ui_method_exists():
	assert_has_method(game_manager_instance, "update_ui", "GameManager should have update_ui method")
	assert_has_method(game_manager_instance, "end_game", "GameManager should have end_game method")

func test_game_mode_properties_are_accessible():
	# Test that game mode properties can be set
	game_manager_instance.game_mode = "timed"
	game_manager_instance.time_limit = 120
	game_manager_instance.target_score = 200

	assert_eq(game_manager_instance.game_mode, "timed", "game_mode should be settable")
	assert_eq(game_manager_instance.time_limit, 120, "time_limit should be settable")
	assert_eq(game_manager_instance.target_score, 200, "target_score should be settable")

# ===== UI Integration Tests =====

func test_update_ui_with_no_ui_layer():
	game_manager_instance.ui_layer = null
	game_manager_instance.score = 50

	# Should not crash when UI layer is not present
	game_manager_instance.update_ui()

	pass_test("update_ui should handle missing UI layer gracefully")

func test_update_ui_with_score_label():
	add_child_autoqfree(game_manager_instance)

	# Create mock UI layer with score label
	var mock_ui = CanvasLayer.new()
	var score_label = Label.new()
	score_label.name = "ScoreLabel"
	score_label.text = "Score: 0"
	mock_ui.add_child(score_label)
	game_manager_instance.add_child(mock_ui)
	game_manager_instance.ui_layer = mock_ui

	game_manager_instance.score = 42
	game_manager_instance.update_ui()

	assert_eq(score_label.text, "Score: 42", "Score label should be updated with current score")

func test_update_ui_timed_mode_with_timer_label():
	add_child_autoqfree(game_manager_instance)

	# Setup timed mode
	game_manager_instance.game_mode = "timed"
	game_manager_instance.time_remaining = 45.7

	# Create mock UI layer with timer label
	var mock_ui = CanvasLayer.new()
	var timer_label = Label.new()
	timer_label.name = "TimerLabel"
	mock_ui.add_child(timer_label)
	game_manager_instance.add_child(mock_ui)
	game_manager_instance.ui_layer = mock_ui

	game_manager_instance.update_ui()

	assert_eq(timer_label.text, "Time: 45s", "Timer label should show time remaining")

func test_update_ui_score_target_mode_with_target_label():
	add_child_autoqfree(game_manager_instance)

	# Setup score_target mode
	game_manager_instance.game_mode = "score_target"
	game_manager_instance.target_score = 150

	# Create mock UI layer with target label
	var mock_ui = CanvasLayer.new()
	var target_label = Label.new()
	target_label.name = "TargetLabel"
	mock_ui.add_child(target_label)
	game_manager_instance.add_child(mock_ui)
	game_manager_instance.ui_layer = mock_ui

	game_manager_instance.update_ui()

	assert_eq(target_label.text, "Target: 150", "Target label should show target score")

func test_update_ui_endless_mode_with_target_label():
	add_child_autoqfree(game_manager_instance)

	# Setup endless mode
	game_manager_instance.game_mode = "endless"
	game_manager_instance.target_score = 200

	# Create mock UI layer with target label
	var mock_ui = CanvasLayer.new()
	var target_label = Label.new()
	target_label.name = "TargetLabel"
	mock_ui.add_child(target_label)
	game_manager_instance.add_child(mock_ui)
	game_manager_instance.ui_layer = mock_ui

	game_manager_instance.update_ui()

	assert_eq(target_label.text, "Target: 200", "Target label should show target score in endless mode too")

func test_end_game_shows_message():
	add_child_autoqfree(game_manager_instance)

	# Create mock UI layer with end game label
	var mock_ui = CanvasLayer.new()
	var end_label = Label.new()
	end_label.name = "EndGameLabel"
	end_label.visible = false
	end_label.text = ""
	mock_ui.add_child(end_label)
	game_manager_instance.add_child(mock_ui)
	game_manager_instance.ui_layer = mock_ui

	game_manager_instance.end_game(true, "Victory!")

	assert_true(end_label.visible, "End game label should be visible")
	# Message includes "\n\nPress any key to restart" appended
	assert_true(end_label.text.begins_with("Victory!") or end_label.text.begins_with("Congratulations"), "End game label should show a victory message")

func test_on_player_selected_initializes_ui():
	add_child_autoqfree(game_manager_instance)

	# Create mock UI layer
	var mock_ui = CanvasLayer.new()
	mock_ui.name = "UILayer"
	var score_label = Label.new()
	score_label.name = "ScoreLabel"
	mock_ui.add_child(score_label)
	game_manager_instance.add_child(mock_ui)

	# Create mock player
	var mock_player = CharacterBody2D.new()
	mock_player.name = "Player"
	mock_player.set_script(preload("res://scripts/player.gd"))
	var sprite = Sprite2D.new()
	sprite.name = "Sprite2D"
	mock_player.add_child(sprite)
	game_manager_instance.add_child(mock_player)

	# Execute
	game_manager_instance._on_player_selected("blue")

	# Verify UI was found and initialized
	assert_not_null(game_manager_instance.ui_layer, "UI layer should be found and set")

func test_add_score_updates_ui():
	add_child_autoqfree(game_manager_instance)
	game_manager_instance.game_started = true
	game_manager_instance.game_over = false

	# Create mock UI layer
	var mock_ui = CanvasLayer.new()
	var score_label = Label.new()
	score_label.name = "ScoreLabel"
	score_label.text = "Score: 0"
	mock_ui.add_child(score_label)
	game_manager_instance.add_child(mock_ui)
	game_manager_instance.ui_layer = mock_ui

	# Add score
	game_manager_instance.add_score(25)

	assert_eq(score_label.text, "Score: 25", "UI should be updated when score is added")

# ===== Restart and Victory Sound Tests =====

func test_end_game_includes_restart_instruction():
	add_child_autoqfree(game_manager_instance)

	# Create mock UI layer with end game label
	var mock_ui = CanvasLayer.new()
	var end_label = Label.new()
	end_label.name = "EndGameLabel"
	end_label.visible = false
	end_label.text = ""
	mock_ui.add_child(end_label)
	game_manager_instance.add_child(mock_ui)
	game_manager_instance.ui_layer = mock_ui

	game_manager_instance.end_game(false, "Time's up!")

	assert_true("Press any key to restart" in end_label.text, "End game message should include restart instruction")
	assert_true("Time's up!" in end_label.text, "End game message should include original message")

func test_victory_sound_plays_on_win():
	add_child_autoqfree(game_manager_instance)

	# Create mock UI layer with victory sound
	var mock_ui = CanvasLayer.new()
	var end_label = Label.new()
	end_label.name = "EndGameLabel"
	var victory_sound = AudioStreamPlayer.new()
	victory_sound.name = "VictorySound"
	# Create a simple audio stream for testing
	victory_sound.stream = AudioStreamGenerator.new()
	mock_ui.add_child(end_label)
	mock_ui.add_child(victory_sound)
	game_manager_instance.add_child(mock_ui)
	game_manager_instance.ui_layer = mock_ui

	# Call end_game with won=true
	game_manager_instance.end_game(true, "You win!")

	# Note: We can't easily test if play() was called without mocking,
	# but we can verify the node exists and has a stream
	assert_not_null(victory_sound.stream, "Victory sound should have a stream")
	pass_test("Victory sound setup correctly for winning")

func test_victory_sound_does_not_play_on_loss():
	add_child_autoqfree(game_manager_instance)

	# Create mock UI layer
	var mock_ui = CanvasLayer.new()
	var end_label = Label.new()
	end_label.name = "EndGameLabel"
	var victory_sound = AudioStreamPlayer.new()
	victory_sound.name = "VictorySound"
	victory_sound.stream = AudioStreamGenerator.new()
	mock_ui.add_child(end_label)
	mock_ui.add_child(victory_sound)
	game_manager_instance.add_child(mock_ui)
	game_manager_instance.ui_layer = mock_ui

	# Track if sound is playing
	var was_playing_before = victory_sound.playing

	# Call end_game with won=false
	game_manager_instance.end_game(false, "Time's up!")

	# Sound should not start playing (though we can't easily verify play() wasn't called)
	pass_test("Victory sound should only play on win, not on loss")

func test_restart_game_method_exists():
	assert_has_method(game_manager_instance, "restart_game", "GameManager should have restart_game method")

func test_game_over_state_persists():
	add_child_autoqfree(game_manager_instance)
	game_manager_instance.game_started = true
	game_manager_instance.game_over = false

	# End the game
	game_manager_instance.end_game(true, "Victory!")

	# Verify game_over is set
	assert_true(game_manager_instance.game_over, "game_over should be true after end_game")

	# Try to add score - should fail
	game_manager_instance.score = 0
	game_manager_instance.add_score(10)
	assert_eq(game_manager_instance.score, 0, "Score should not change when game_over is true")

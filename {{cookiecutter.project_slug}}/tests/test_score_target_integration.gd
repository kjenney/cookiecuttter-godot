extends GutTest

# Integration test for score_target mode win condition

var GameManager = preload("res://scripts/game_manager.gd")
var game_manager = null

func before_each():
	game_manager = autoqfree(Node.new())
	game_manager.set_script(GameManager)
	game_manager.game_mode = "score_target"
	game_manager.target_score = 100
	game_manager.game_started = true
	game_manager.game_over = false
	game_manager.score = 0

func after_each():
	game_manager = null

func test_reaching_target_score_triggers_win():
	add_child_autoqfree(game_manager)

	# Create mock UI with EndGameLabel
	var mock_ui = CanvasLayer.new()
	var end_label = Label.new()
	end_label.name = "EndGameLabel"
	end_label.visible = false
	end_label.text = ""
	mock_ui.add_child(end_label)
	game_manager.add_child(mock_ui)
	game_manager.ui_layer = mock_ui

	# Add score to reach exactly the target
	game_manager.add_score(100)

	# Verify win conditions
	assert_true(game_manager.game_over, "game_over should be true")
	assert_true(get_tree().paused, "Game should be paused")
	assert_true(end_label.visible, "End game label should be visible")
	# Message includes "\n\nPress any key to restart" or might be "Congratulations! All levels completed!"
	assert_true(end_label.text.contains("win") or end_label.text.contains("Congratulations"), "Victory message should be displayed")

func test_exceeding_target_score_triggers_win():
	add_child_autoqfree(game_manager)

	# Create mock UI with EndGameLabel
	var mock_ui = CanvasLayer.new()
	var end_label = Label.new()
	end_label.name = "EndGameLabel"
	end_label.visible = false
	mock_ui.add_child(end_label)
	game_manager.add_child(mock_ui)
	game_manager.ui_layer = mock_ui

	# Score incrementally and verify it triggers at the right moment
	game_manager.add_score(50)
	assert_false(game_manager.game_over, "Should not be game over at 50 points")
	assert_false(end_label.visible, "Label should not be visible yet")

	game_manager.add_score(60)  # Total: 110, exceeds target of 100
	assert_true(game_manager.game_over, "Should be game over after exceeding target")
	assert_true(end_label.visible, "Label should now be visible")

func test_cannot_score_after_winning():
	add_child_autoqfree(game_manager)

	# Reach target score
	game_manager.add_score(100)
	assert_eq(game_manager.score, 100, "Score should be 100")

	# Try to add more score after winning
	game_manager.add_score(50)
	assert_eq(game_manager.score, 100, "Score should remain 100 after game over")

extends GutTest

# Test suite for Collectible functionality

var Collectible = preload("res://scripts/collectible.gd")
var collectible_instance = null

func before_each():
	# Create a fresh collectible instance before each test
	collectible_instance = autoqfree(Area2D.new())
	collectible_instance.set_script(Collectible)

func after_each():
	collectible_instance = null

func test_collectible_exists():
	assert_not_null(collectible_instance, "Collectible instance should exist")

func test_collectible_has_body_entered_handler():
	assert_has_method(collectible_instance, "_on_body_entered", "Collectible should have _on_body_entered method")

func test_collectible_ignores_non_player():
	# Setup: Create a non-player body
	var non_player = CharacterBody2D.new()
	non_player.name = "NotPlayer"
	add_child_autoqfree(non_player)
	add_child_autoqfree(collectible_instance)

	# Execute: Simulate non-player entering collectible area
	# This should not crash and collectible should not be queued for deletion
	collectible_instance._on_body_entered(non_player)

	# Verify: Collectible should NOT be queued for deletion when non-player enters
	assert_false(collectible_instance.is_queued_for_deletion(),
		"Collectible should not be queued for deletion when non-player body enters")

func test_collectible_queues_for_deletion_on_player():
	# Setup
	var mock_player = CharacterBody2D.new()
	mock_player.name = "Player"
	add_child_autoqfree(mock_player)
	add_child_autoqfree(collectible_instance)

	# Execute: Simulate player entering collectible area
	collectible_instance._on_body_entered(mock_player)

	# Wait for deferred call to process (call_deferred("queue_free") happens next frame)
	await get_tree().process_frame

	# Verify: Collectible should be queued for deletion after player collection
	assert_true(collectible_instance.is_queued_for_deletion(),
		"Collectible should be queued for deletion after player collects it")

func test_collectible_checks_player_name():
	# Test that collectible specifically checks for "Player" name
	var body_with_wrong_name = CharacterBody2D.new()
	body_with_wrong_name.name = "Enemy"
	add_child_autoqfree(body_with_wrong_name)
	add_child_autoqfree(collectible_instance)

	collectible_instance._on_body_entered(body_with_wrong_name)

	assert_false(collectible_instance.is_queued_for_deletion(),
		"Collectible should only respond to body named 'Player'")

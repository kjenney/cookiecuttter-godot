extends GutTest

# Test suite for Collectible functionality

var Collectible = preload("res://scripts/collectible.gd")
var collectible_instance = null
var mock_player = null
var mock_main_scene = null

func before_each():
	# Create a fresh collectible instance before each test
	collectible_instance = autoqfree(Area2D.new())
	collectible_instance.set_script(Collectible)
	
	# Create a mock player
	mock_player = CharacterBody2D.new()
	mock_player.name = "Player"
	add_child_autoqfree(mock_player)
	
	# Create a mock main scene with add_score method
	mock_main_scene = Node.new()
	mock_main_scene.score = 0
	mock_main_scene.set_script(GDScript.new())
	mock_main_scene.get_script().source_code = """
extends Node
var score = 0
func add_score(points):
	score += points
"""
	mock_main_scene.get_script().reload()
	add_child_autoqfree(mock_main_scene)

func after_each():
	collectible_instance = null
	mock_player = null
	mock_main_scene = null

func test_collectible_exists():
	assert_not_null(collectible_instance, "Collectible instance should exist")

func test_collectible_has_body_entered_handler():
	assert_has(collectible_instance, "_on_body_entered", "Collectible should have _on_body_entered method")

func test_collectible_responds_to_player():
	# Setup: Add collectible to scene tree
	add_child_autoqfree(collectible_instance)
	
	# Stub the get_tree().current_scene to return our mock main scene
	stub(collectible_instance, "get_tree").to_return(get_tree())
	stub(get_tree(), "current_scene").to_return(mock_main_scene)
	
	# Execute: Simulate player entering collectible area
	collectible_instance._on_body_entered(mock_player)
	
	# Verify: Check that score was added
	assert_eq(mock_main_scene.score, 10, "Score should be increased by 10 when player collects item")

func test_collectible_ignores_non_player():
	# Setup: Create a non-player body
	var non_player = CharacterBody2D.new()
	non_player.name = "NotPlayer"
	add_child_autoqfree(non_player)
	add_child_autoqfree(collectible_instance)
	
	stub(collectible_instance, "get_tree").to_return(get_tree())
	stub(get_tree(), "current_scene").to_return(mock_main_scene)
	
	# Execute: Simulate non-player entering collectible area
	collectible_instance._on_body_entered(non_player)
	
	# Verify: Score should not change
	assert_eq(mock_main_scene.score, 0, "Score should not change when non-player body enters")

func test_collectible_queues_for_deletion():
	# Setup
	add_child_autoqfree(collectible_instance)
	stub(collectible_instance, "get_tree").to_return(get_tree())
	stub(get_tree(), "current_scene").to_return(mock_main_scene)
	
	# Execute
	collectible_instance._on_body_entered(mock_player)
	
	# Verify: Collectible should be marked for deletion
	# Note: We can't directly test queue_free() but we can verify it was called
	assert_true(collectible_instance.is_queued_for_deletion(), "Collectible should be queued for deletion after collection")

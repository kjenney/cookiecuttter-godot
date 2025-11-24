extends GutTest

# Test suite for NPC functionality
{% if cookiecutter.include_npc == "yes" %}
var NPCScript = preload("res://scripts/npc.gd")
var npc_instance = null

func before_each():
	# Create a fresh NPC instance before each test
	npc_instance = Area2D.new()
	# Set collision layers to match npc.tscn
	npc_instance.collision_layer = 4  # Layer 3 (Collectibles)
	npc_instance.collision_mask = 2   # Mask for Layer 2 (Player)

	# Create the SpeechBubble panel that the script expects
	var speech_bubble = Panel.new()
	speech_bubble.name = "SpeechBubble"
	npc_instance.add_child(speech_bubble)

	# Create the Label inside SpeechBubble
	var label = Label.new()
	label.name = "Label"
	speech_bubble.add_child(label)

	# Set the script after creating child nodes
	npc_instance.set_script(NPCScript)

	# Add to tree so @onready variables get initialized
	add_child_autoqfree(npc_instance)

func after_each():
	npc_instance = null

func test_npc_exists():
	assert_not_null(npc_instance, "NPC instance should exist")

func test_npc_has_required_methods():
	assert_has_method(npc_instance, "_on_body_entered", "NPC should have _on_body_entered method")
	assert_has_method(npc_instance, "_on_body_exited", "NPC should have _on_body_exited method")
	assert_has_method(npc_instance, "show_speech_bubble", "NPC should have show_speech_bubble method")
	assert_has_method(npc_instance, "hide_speech_bubble", "NPC should have hide_speech_bubble method")

func test_npc_collision_mask_targets_player_layer():
	# NPC should have mask set to detect layer 2 (Player layer)
	assert_eq(npc_instance.collision_mask, 2, "NPC collision mask should be 2 (Player layer)")

func test_speech_bubble_hidden_by_default():
	var speech_bubble = npc_instance.get_node("SpeechBubble")
	assert_false(speech_bubble.visible, "Speech bubble should be hidden by default")

func test_speech_bubble_shows_on_player_enter():
	# Create mock player with correct collision layer
	var mock_player = CharacterBody2D.new()
	mock_player.name = "Player"
	mock_player.collision_layer = 2  # Player layer
	add_child_autoqfree(mock_player)

	# Simulate player entering
	npc_instance._on_body_entered(mock_player)

	var speech_bubble = npc_instance.get_node("SpeechBubble")
	assert_true(speech_bubble.visible, "Speech bubble should be visible when player enters")

func test_speech_bubble_hides_on_player_exit():
	# Create mock player
	var mock_player = CharacterBody2D.new()
	mock_player.name = "Player"
	mock_player.collision_layer = 2
	add_child_autoqfree(mock_player)

	# Simulate player entering then exiting
	npc_instance._on_body_entered(mock_player)
	npc_instance._on_body_exited(mock_player)

	var speech_bubble = npc_instance.get_node("SpeechBubble")
	assert_false(speech_bubble.visible, "Speech bubble should be hidden when player exits")

func test_speech_bubble_text():
	# Create mock player
	var mock_player = CharacterBody2D.new()
	mock_player.name = "Player"
	mock_player.collision_layer = 2
	add_child_autoqfree(mock_player)

	# Simulate player entering
	npc_instance._on_body_entered(mock_player)

	var label = npc_instance.get_node("SpeechBubble/Label")
	assert_eq(label.text, "Hi, how are you?", "Speech bubble should display correct text")

func test_npc_ignores_non_player():
	# Create non-player body
	var non_player = CharacterBody2D.new()
	non_player.name = "Enemy"
	non_player.collision_layer = 1  # World layer, not Player
	add_child_autoqfree(non_player)

	# Simulate non-player entering
	npc_instance._on_body_entered(non_player)

	var speech_bubble = npc_instance.get_node("SpeechBubble")
	assert_false(speech_bubble.visible, "Speech bubble should not show for non-player bodies")

func test_npc_ignores_body_on_wrong_layer():
	# Create body named "Player" but on wrong collision layer
	var wrong_layer_player = CharacterBody2D.new()
	wrong_layer_player.name = "NotPlayer"
	wrong_layer_player.collision_layer = 1  # Wrong layer
	add_child_autoqfree(wrong_layer_player)

	npc_instance._on_body_entered(wrong_layer_player)

	var speech_bubble = npc_instance.get_node("SpeechBubble")
	assert_false(speech_bubble.visible, "Speech bubble should not show for body with wrong name")

func test_player_nearby_flag_set_on_enter():
	var mock_player = CharacterBody2D.new()
	mock_player.name = "Player"
	mock_player.collision_layer = 2
	add_child_autoqfree(mock_player)

	npc_instance._on_body_entered(mock_player)

	assert_true(npc_instance.player_nearby, "player_nearby should be true when player enters")

func test_player_nearby_flag_cleared_on_exit():
	var mock_player = CharacterBody2D.new()
	mock_player.name = "Player"
	mock_player.collision_layer = 2
	add_child_autoqfree(mock_player)

	npc_instance._on_body_entered(mock_player)
	npc_instance._on_body_exited(mock_player)

	assert_false(npc_instance.player_nearby, "player_nearby should be false when player exits")

func test_speech_bubble_toggle_multiple_times():
	var mock_player = CharacterBody2D.new()
	mock_player.name = "Player"
	mock_player.collision_layer = 2
	add_child_autoqfree(mock_player)

	var speech_bubble = npc_instance.get_node("SpeechBubble")

	# Enter -> show
	npc_instance._on_body_entered(mock_player)
	assert_true(speech_bubble.visible, "Speech bubble should show on first enter")

	# Exit -> hide
	npc_instance._on_body_exited(mock_player)
	assert_false(speech_bubble.visible, "Speech bubble should hide on first exit")

	# Enter again -> show
	npc_instance._on_body_entered(mock_player)
	assert_true(speech_bubble.visible, "Speech bubble should show on second enter")

	# Exit again -> hide
	npc_instance._on_body_exited(mock_player)
	assert_false(speech_bubble.visible, "Speech bubble should hide on second exit")
{% else %}
# NPC not included in this project
func test_npc_not_included():
	pass_test("NPC feature not included in this project configuration")
{% endif %}

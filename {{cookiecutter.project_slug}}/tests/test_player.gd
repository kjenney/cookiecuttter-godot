extends GutTest

# Test suite for Player functionality

var Player = preload("res://scripts/player.gd")
var player_instance = null

func before_each():
	# Create a fresh player instance before each test
	player_instance = autoqfree(CharacterBody2D.new())
	player_instance.set_script(Player)
	# Add an AnimatedSprite2D child node as the player script expects it
	var sprite = AnimatedSprite2D.new()
	sprite.name = "AnimatedSprite2D"
	# Create sprite frames with animations
	var sprite_frames = SpriteFrames.new()
	sprite_frames.add_animation("idle")
	sprite_frames.add_animation("walk")
	sprite_frames.add_animation("collect")
	sprite.sprite_frames = sprite_frames
	player_instance.add_child(sprite)
	player_instance._ready()

func after_each():
	# Cleanup happens automatically with autoqfree
	player_instance = null

func test_player_default_type():
	assert_eq(player_instance.player_type, "blue", "Player should default to blue type")

func test_player_speed_default():
	assert_eq(player_instance.speed, 300.0, "Player speed should be 300.0 by default")

func test_set_player_type_blue():
	player_instance.set_player_type("blue")
	assert_eq(player_instance.player_type, "blue", "Player type should be set to blue")
	var sprite = player_instance.get_node("AnimatedSprite2D")
	assert_not_null(sprite, "AnimatedSprite2D should exist")
	# Modulate is WHITE when using SVG textures, colored when using default appearance
	assert_true(sprite.modulate == Color.WHITE or sprite.modulate == Color(0.3, 0.5, 1.0), "Blue player should have white (SVG) or blue (default) modulation")

func test_set_player_type_red():
	player_instance.set_player_type("red")
	assert_eq(player_instance.player_type, "red", "Player type should be set to red")
	var sprite = player_instance.get_node("AnimatedSprite2D")
	assert_not_null(sprite, "AnimatedSprite2D should exist")
	# Modulate is WHITE when using SVG textures, colored when using default appearance
	assert_true(sprite.modulate == Color.WHITE or sprite.modulate == Color(1.0, 0.3, 0.3), "Red player should have white (SVG) or red (default) modulation")

func test_set_player_type_green():
	player_instance.set_player_type("green")
	assert_eq(player_instance.player_type, "green", "Player type should be set to green")
	var sprite = player_instance.get_node("AnimatedSprite2D")
	assert_not_null(sprite, "AnimatedSprite2D should exist")
	# Modulate is WHITE when using SVG textures, colored when using default appearance
	assert_true(sprite.modulate == Color.WHITE or sprite.modulate == Color(0.3, 1.0, 0.5), "Green player should have white (SVG) or green (default) modulation")

func test_set_player_type_invalid():
	player_instance.set_player_type("invalid_type")
	assert_eq(player_instance.player_type, "invalid_type", "Player type should be set even if invalid")
	var sprite = player_instance.get_node("Sprite2D")
	assert_eq(sprite.modulate, Color.WHITE, "Invalid player type should default to white color")

func test_player_velocity_initialization():
	assert_eq(player_instance.velocity, Vector2.ZERO, "Player velocity should start at zero")

func test_player_has_physics_process():
	assert_has_method(player_instance, "_physics_process", "Player should have _physics_process method")

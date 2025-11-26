extends Node

# LevelManager singleton - handles level transitions and state
# Add this as an autoload in Project Settings

var levels_config = []
var current_level_index = 0
var player_type = "blue"  # Persists between levels

func _ready():
	load_levels_config()

func load_levels_config():
	"""Load levels configuration from JSON file"""
	var config_path = "res://levels_config.json"

	if FileAccess.file_exists(config_path):
		var file = FileAccess.open(config_path, FileAccess.READ)
		if file:
			var json_string = file.get_as_text()
			file.close()

			var json = JSON.new()
			var error = json.parse(json_string)

			if error == OK:
				var data = json.data
				if data.has("levels"):
					levels_config = data["levels"]
					print("LevelManager: Loaded ", levels_config.size(), " level(s)")
				else:
					push_warning("LevelManager: No 'levels' key in config")
			else:
				push_error("LevelManager: JSON Parse Error: ", json.get_error_message())
	else:
		print("LevelManager: No levels config found - single level mode")

func get_current_level_config():
	"""Get configuration for the current level"""
	if current_level_index < levels_config.size():
		return levels_config[current_level_index]
	return null

func get_level_count():
	"""Get total number of levels"""
	return levels_config.size()

func is_multi_level():
	"""Check if game has multiple levels"""
	return levels_config.size() > 1

func next_level():
	"""Advance to the next level"""
	if current_level_index < levels_config.size() - 1:
		current_level_index += 1
		print("LevelManager: Advancing to level ", current_level_index + 1)
		return true
	else:
		print("LevelManager: All levels completed!")
		return false

func restart_levels():
	"""Reset to first level"""
	current_level_index = 0
	print("LevelManager: Restarting from level 1")

func load_current_level():
	"""Load the current level scene"""
	var level_config = get_current_level_config()
	if level_config:
		var level_name = level_config.get("name", "level_1")
		var level_path = "res://scenes/" + level_name + ".tscn"

		if ResourceLoader.exists(level_path):
			get_tree().change_scene_to_file(level_path)
			print("LevelManager: Loading level scene: ", level_path)
		else:
			push_error("LevelManager: Level scene not found: ", level_path)
			# Fallback to main scene
			get_tree().change_scene_to_file("res://scenes/main.tscn")
	else:
		# Single level mode - use main scene
		get_tree().change_scene_to_file("res://scenes/main.tscn")

func set_player_type(type: String):
	"""Store selected player type across levels"""
	player_type = type
	print("LevelManager: Player type set to: ", type)

func get_player_type() -> String:
	"""Get the current player type"""
	return player_type

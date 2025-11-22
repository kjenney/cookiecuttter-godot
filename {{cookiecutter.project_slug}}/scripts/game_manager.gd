extends Node

var score = 0
var player_select_scene = preload("res://scenes/player_select.tscn")
var player_select_instance = null
var game_started = false

func _ready():
	print("Game Manager ready!")
	show_player_select()

func show_player_select():
	print("Showing player select menu...")
	player_select_instance = player_select_scene.instantiate()
	player_select_instance.player_selected.connect(_on_player_selected)
	# Add to scene root using call_deferred to avoid "parent is busy" error
	get_tree().root.call_deferred("add_child", player_select_instance)
	print("Player select menu queued to be added to scene root")
	print("Pausing game tree...")
	get_tree().paused = true
	print("Game tree paused: ", get_tree().paused)

func _on_player_selected(player_type: String):
	get_tree().paused = false
	game_started = true
	
	# Apply the selected player type to the player
	print("Looking for Player node...")
	print("Current node (self): ", self.name)
	print("Children: ", get_children())
	
	var player = get_node_or_null("Player")
	if player:
		print("Found Player node: ", player)
		if player.has_method("set_player_type"):
			player.set_player_type(player_type)
			print("Successfully set player type to: ", player_type)
		else:
			print("Warning: Player node doesn't have set_player_type method")
	else:
		print("Warning: Could not find Player node")
	
	print("Game started with ", player_type, " player!")



func add_score(points):
	score += points
	print("Score: ", score)

extends Node

var score = 0
var player_select_scene = preload("res://scenes/player_select.tscn")
var player_select_instance = null
var game_started = false

# Game mode settings
var game_mode = "{{ cookiecutter.game_mode }}"
var time_limit = {{ cookiecutter.time_limit }}
var target_score = {{ cookiecutter.target_score }}
var time_remaining = 0.0
var game_over = false

# UI reference
var ui_layer = null

func _ready():
	print("Game Manager ready!")
	print("Game mode: ", game_mode)
	if game_mode == "timed":
		print("Time limit: ", time_limit, " seconds")
		time_remaining = float(time_limit)
	elif game_mode == "score_target":
		print("Target score: ", target_score)
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

	# Find and initialize UI
	ui_layer = get_node_or_null("UILayer")
	if ui_layer:
		update_ui()

func _process(delta):
	if not game_started or game_over:
		return

	# Handle timed mode
	if game_mode == "timed":
		time_remaining -= delta
		update_ui()

		if time_remaining <= 0:
			end_game(false, "Time's up! Final score: " + str(score))

func add_score(points):
	if game_over:
		return

	score += points
	print("Score: ", score)
	update_ui()

	# Check win condition - target score reached in any mode
	if score >= target_score:
		end_game(true, "You win! Target score reached!")

func update_ui():
	if not ui_layer:
		return

	# Update score label
	var score_label = ui_layer.get_node_or_null("ScoreLabel")
	if score_label:
		score_label.text = "Score: " + str(score)

	# Update timer label for timed mode
	if game_mode == "timed":
		var timer_label = ui_layer.get_node_or_null("TimerLabel")
		if timer_label:
			timer_label.text = "Time: " + str(int(time_remaining)) + "s"

	# Always update target label (target score applies to all modes)
	var target_label = ui_layer.get_node_or_null("TargetLabel")
	if target_label:
		target_label.text = "Target: " + str(target_score)

func end_game(won: bool, message: String):
	game_over = true
	print(message)
	get_tree().paused = true

	# Show end game message with restart instruction
	if ui_layer:
		var end_label = ui_layer.get_node_or_null("EndGameLabel")
		if end_label:
			end_label.text = message + "\n\nPress SPACE to restart"
			end_label.visible = true

		# Play victory sound if won
		if won:
			var victory_sound = ui_layer.get_node_or_null("VictorySound")
			if victory_sound and victory_sound.stream:
				victory_sound.play()

func _input(event):
	# Handle restart when game is over
	if game_over and event.is_action_pressed("ui_select"):
		restart_game()

func restart_game():
	get_tree().paused = false
	get_tree().reload_current_scene()

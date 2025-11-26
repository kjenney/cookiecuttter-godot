extends Control

signal player_selected(player_type: String)

# Available player types from cookiecutter configuration
var available_types = "{{ cookiecutter.player_types }}".split(",")
var selected_player = available_types[0] if available_types.size() > 0 else "blue"
var selected_index = 0

var buttons = {}

func _ready():
	print("PlayerSelect menu ready!")
	print("Process mode: ", process_mode)
	print("Available player types: ", available_types)
	
	# Create buttons dynamically based on available types
	_create_ui()
	_update_selection()

func _create_ui():
	# Get the VBoxContainer
	var vbox = $VBoxContainer
	
	# Clear any existing buttons (except title)
	for child in vbox.get_children():
		if child.name != "Title":
			child.queue_free()
	
	# Create a button for each available player type
	for player_type in available_types:
		var button = Button.new()
		button.text = player_type.capitalize() + " Player"
		button.custom_minimum_size = Vector2(200, 40)
		button.name = player_type.capitalize() + "Button"
		button.pressed.connect(_on_player_button_pressed.bind(player_type))
		vbox.add_child(button)
		buttons[player_type] = button
		print("Created button for: ", player_type)
	
	# Create Start Game button
	var start_button = Button.new()
	start_button.text = "Start Game"
	start_button.custom_minimum_size = Vector2(200, 50)
	start_button.name = "StartButton"
	start_button.pressed.connect(_on_start_pressed)
	vbox.add_child(start_button)
	print("All buttons created!")

func _on_player_button_pressed(player_type: String):
	print(player_type.capitalize(), " button pressed!")
	selected_player = player_type
	selected_index = available_types.find(player_type)
	_update_selection()

func _update_selection():
	# Update button text and appearance to show selection
	for player_type in available_types:
		if player_type in buttons:
			var button = buttons[player_type]
			if selected_player == player_type:
				button.text = "→ " + player_type.capitalize() + " Player ←"
				button.modulate = Color(1.5, 1.5, 1.5)  # Brighter
			else:
				button.text = player_type.capitalize() + " Player"
				button.modulate = Color(1.0, 1.0, 1.0)  # Normal
	print("Selection updated to: ", selected_player)

func _on_start_pressed():
	print("Start button pressed! Emitting signal with player type: ", selected_player)
	player_selected.emit(selected_player)
	print("Signal emitted, removing menu...")
	queue_free()

func _input(event):
	# Handle arrow key navigation
	if event.is_action_pressed("ui_left") or event.is_action_pressed("ui_up"):
		_navigate_previous()
	elif event.is_action_pressed("ui_right") or event.is_action_pressed("ui_down"):
		_navigate_next()
	elif event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_select"):
		# ENTER or SPACE starts the game
		_on_start_pressed()

func _navigate_previous():
	selected_index -= 1
	if selected_index < 0:
		selected_index = available_types.size() - 1
	selected_player = available_types[selected_index]
	_update_selection()
	print("Navigated to: ", selected_player)

func _navigate_next():
	selected_index += 1
	if selected_index >= available_types.size():
		selected_index = 0
	selected_player = available_types[selected_index]
	_update_selection()
	print("Navigated to: ", selected_player)

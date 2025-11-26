extends GutTest

# Test suite for PlayerSelect functionality

var PlayerSelectScript = preload("res://scripts/player_select.gd")
var player_select_instance = null

func before_each():
	# Create a fresh player select instance before each test
	player_select_instance = autoqfree(Control.new())
	player_select_instance.set_script(PlayerSelectScript)
	
	# Create the VBoxContainer that the script expects
	var vbox = VBoxContainer.new()
	vbox.name = "VBoxContainer"
	player_select_instance.add_child(vbox)
	
	# Create a title label
	var title = Label.new()
	title.name = "Title"
	title.text = "Select Your Player"
	vbox.add_child(title)

func after_each():
	player_select_instance = null

func test_player_select_exists():
	assert_not_null(player_select_instance, "PlayerSelect instance should exist")

func test_player_select_has_signal():
	assert_has_signal(player_select_instance, "player_selected", "PlayerSelect should have player_selected signal")

func test_available_types_parsed():
	player_select_instance._ready()
	assert_gt(player_select_instance.available_types.size(), 0, "Should have at least one available player type")

func test_default_selection():
	player_select_instance._ready()
	assert_not_null(player_select_instance.selected_player, "Should have a default selected player")
	assert_eq(player_select_instance.selected_player, player_select_instance.available_types[0], 
		"Default selection should be first available type")

func test_ui_creation():
	player_select_instance._ready()
	var vbox = player_select_instance.get_node("VBoxContainer")
	
	# Should have: Title + buttons for each player type + Start button
	var expected_children = 1 + player_select_instance.available_types.size() + 1
	assert_eq(vbox.get_child_count(), expected_children, 
		"VBoxContainer should have correct number of children")

func test_buttons_created_for_all_types():
	player_select_instance._ready()
	
	for player_type in player_select_instance.available_types:
		assert_true(player_type in player_select_instance.buttons, 
			"Should have button for player type: " + player_type)

func test_player_button_selection():
	player_select_instance._ready()
	
	# Simulate pressing a player button
	if player_select_instance.available_types.size() > 1:
		var second_type = player_select_instance.available_types[1]
		player_select_instance._on_player_button_pressed(second_type)
		
		assert_eq(player_select_instance.selected_player, second_type, 
			"Selected player should change when button is pressed")

func test_selection_marker_update():
	player_select_instance._ready()

	if player_select_instance.available_types.size() > 0:
		var first_type = player_select_instance.available_types[0]
		player_select_instance._on_player_button_pressed(first_type)
		player_select_instance._update_selection()

		var button = player_select_instance.buttons[first_type]
		assert_string_contains(button.text, "→",
			"Selected button should show arrow markers")
		assert_gt(button.modulate.r, 1.0,
			"Selected button should be brighter")

func test_start_button_emits_signal():
	add_child_autoqfree(player_select_instance)
	player_select_instance._ready()
	
	# Watch for the signal
	watch_signals(player_select_instance)
	
	# Simulate pressing start button
	player_select_instance._on_start_pressed()
	
	# Verify signal was emitted
	assert_signal_emitted(player_select_instance, "player_selected")

func test_start_button_emits_correct_player_type():
	add_child_autoqfree(player_select_instance)
	player_select_instance._ready()
	
	watch_signals(player_select_instance)
	
	# Set a specific player type
	if player_select_instance.available_types.size() > 1:
		var test_type = player_select_instance.available_types[1]
		player_select_instance._on_player_button_pressed(test_type)
		player_select_instance._on_start_pressed()
		
		assert_signal_emitted_with_parameters(player_select_instance, "player_selected", [test_type])

func test_menu_queues_for_deletion_on_start():
	add_child_autoqfree(player_select_instance)
	player_select_instance._ready()
	
	player_select_instance._on_start_pressed()
	
	assert_true(player_select_instance.is_queued_for_deletion(), 
		"PlayerSelect menu should be queued for deletion after start")

func test_has_required_methods():
	assert_has_method(player_select_instance, "_create_ui", "Should have _create_ui method")
	assert_has_method(player_select_instance, "_update_selection", "Should have _update_selection method")
	assert_has_method(player_select_instance, "_on_player_button_pressed", "Should have _on_player_button_pressed method")
	assert_has_method(player_select_instance, "_on_start_pressed", "Should have _on_start_pressed method")
	assert_has_method(player_select_instance, "_navigate_next", "Should have _navigate_next method")
	assert_has_method(player_select_instance, "_navigate_previous", "Should have _navigate_previous method")

# ===== Arrow Key Navigation Tests =====

func test_navigate_next():
	player_select_instance._ready()

	if player_select_instance.available_types.size() > 1:
		var first_type = player_select_instance.available_types[0]
		var second_type = player_select_instance.available_types[1]

		assert_eq(player_select_instance.selected_player, first_type, "Should start with first type")

		player_select_instance._navigate_next()

		assert_eq(player_select_instance.selected_player, second_type, "Should move to second type")
		assert_eq(player_select_instance.selected_index, 1, "Selected index should be 1")

func test_navigate_previous():
	player_select_instance._ready()

	if player_select_instance.available_types.size() > 1:
		var first_type = player_select_instance.available_types[0]
		var last_type = player_select_instance.available_types[player_select_instance.available_types.size() - 1]

		# Start at first, go previous should wrap to last
		player_select_instance._navigate_previous()

		assert_eq(player_select_instance.selected_player, last_type, "Should wrap to last type")
		assert_eq(player_select_instance.selected_index, player_select_instance.available_types.size() - 1,
			"Selected index should be last index")

func test_navigate_wraps_around():
	player_select_instance._ready()

	if player_select_instance.available_types.size() > 1:
		var first_type = player_select_instance.available_types[0]
		var last_index = player_select_instance.available_types.size() - 1

		# Navigate to last
		for i in range(last_index + 1):
			player_select_instance._navigate_next()

		# Should wrap back to first
		assert_eq(player_select_instance.selected_player, first_type, "Should wrap around to first type")
		assert_eq(player_select_instance.selected_index, 0, "Index should wrap to 0")

func test_selected_index_syncs_with_button_press():
	player_select_instance._ready()

	if player_select_instance.available_types.size() > 1:
		var second_type = player_select_instance.available_types[1]

		player_select_instance._on_player_button_pressed(second_type)

		assert_eq(player_select_instance.selected_index, 1, "Selected index should update when button is pressed")
		assert_eq(player_select_instance.selected_player, second_type, "Selected player should match")

func test_navigate_updates_visual_selection():
	player_select_instance._ready()

	if player_select_instance.available_types.size() > 1:
		var first_type = player_select_instance.available_types[0]
		var second_type = player_select_instance.available_types[1]

		# Navigate to next
		player_select_instance._navigate_next()

		# Check first button is not highlighted
		var first_button = player_select_instance.buttons[first_type]
		assert_false("→" in first_button.text, "First button should not have arrows")
		assert_eq(first_button.modulate.r, 1.0, "First button should have normal brightness")

		# Check second button is highlighted
		var second_button = player_select_instance.buttons[second_type]
		assert_true("→" in second_button.text, "Second button should have arrows")
		assert_gt(second_button.modulate.r, 1.0, "Second button should be brighter")

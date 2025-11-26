extends CharacterBody2D

@export var speed = 300.0
var player_type = "blue"

func _ready():
	set_player_type(player_type)

func set_player_type(type: String):
	player_type = type
	var sprite = $Sprite2D

	# Try to load type-specific SVG first
	var type_specific_path = "res://assets/player_" + type + ".svg"
	if ResourceLoader.exists(type_specific_path):
		var texture = load(type_specific_path)
		if texture:
			sprite.texture = texture
			# Keep sprite white so SVG colors show through
			sprite.modulate = Color.WHITE
			print("Loaded type-specific SVG: ", type_specific_path)
		else:
			push_warning("Failed to load texture: " + type_specific_path)
			_use_default_appearance(sprite, type)
	else:
		print("Type-specific SVG not found: ", type_specific_path)
		_use_default_appearance(sprite, type)

func _use_default_appearance(sprite: Sprite2D, type: String):
	"""Fallback to a simple colored square if no texture is available"""
	# Create a simple colored rectangle as fallback
	if not sprite.texture:
		# Create a 128x128 white square texture
		var img = Image.create(128, 128, false, Image.FORMAT_RGBA8)
		img.fill(Color.WHITE)
		var texture = ImageTexture.create_from_image(img)
		sprite.texture = texture

	# Apply color modulation based on type
	match type:
		"blue":
			sprite.modulate = Color(0.3, 0.5, 1.0)
		"red":
			sprite.modulate = Color(1.0, 0.3, 0.3)
		"green":
			sprite.modulate = Color(0.3, 1.0, 0.5)
		_:
			sprite.modulate = Color.WHITE
	print("Using default colored square for player type: ", type)

func _physics_process(_delta):
	var direction_x = Input.get_axis("ui_left", "ui_right")
	var direction_y = Input.get_axis("ui_up", "ui_down")
	
	if direction_x:
		velocity.x = direction_x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	if direction_y:
		velocity.y = direction_y * speed
	else:
		velocity.y = move_toward(velocity.y, 0, speed)

	move_and_slide()

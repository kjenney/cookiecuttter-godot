extends CharacterBody2D

@export var speed = 300.0
var player_type = "blue"
var is_collecting = false

@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	set_player_type(player_type)
	# Connect animation finished signal
	if animated_sprite:
		animated_sprite.animation_finished.connect(_on_animation_finished)

func set_player_type(type: String):
	player_type = type

	# Try to load type-specific SVG first
	var type_specific_path = "res://assets/player_" + type + ".svg"
	if ResourceLoader.exists(type_specific_path):
		var texture = load(type_specific_path)
		if texture:
			_setup_animations_with_texture(texture)
			# Keep sprite white so SVG colors show through
			animated_sprite.modulate = Color.WHITE
			print("Loaded type-specific SVG: ", type_specific_path)
		else:
			push_warning("Failed to load texture: " + type_specific_path)
			_use_default_appearance(type)
	else:
		print("Type-specific SVG not found: ", type_specific_path)
		_use_default_appearance(type)

func _setup_animations_with_texture(texture: Texture2D):
	"""Set up all animation frames with the given texture"""
	if not animated_sprite or not animated_sprite.sprite_frames:
		return

	var sprite_frames = animated_sprite.sprite_frames

	# Add texture to idle animation
	if sprite_frames.has_animation("idle"):
		sprite_frames.clear("idle")
		sprite_frames.add_frame("idle", texture)

	# Add texture to walk animation
	if sprite_frames.has_animation("walk"):
		sprite_frames.clear("walk")
		sprite_frames.add_frame("walk", texture)

	# Add texture to collect animation
	if sprite_frames.has_animation("collect"):
		sprite_frames.clear("collect")
		sprite_frames.add_frame("collect", texture)

func _use_default_appearance(type: String):
	"""Fallback to a simple colored square if no texture is available"""
	# Create a 128x128 white square texture
	var img = Image.create(128, 128, false, Image.FORMAT_RGBA8)
	img.fill(Color.WHITE)
	var texture = ImageTexture.create_from_image(img)

	_setup_animations_with_texture(texture)

	# Apply color modulation based on type
	match type:
		"blue":
			animated_sprite.modulate = Color(0.3, 0.5, 1.0)
		"red":
			animated_sprite.modulate = Color(1.0, 0.3, 0.3)
		"green":
			animated_sprite.modulate = Color(0.3, 1.0, 0.5)
		_:
			animated_sprite.modulate = Color.WHITE
	print("Using default colored square for player type: ", type)

func play_collect_animation():
	"""Trigger the collection animation"""
	if animated_sprite and not is_collecting:
		is_collecting = true
		animated_sprite.play("collect")

func _on_animation_finished():
	"""Called when any animation finishes"""
	if is_collecting:
		is_collecting = false
		# Return to idle or walk based on movement
		_update_animation()

func _update_animation():
	"""Update animation based on current movement state"""
	if is_collecting or not animated_sprite:
		return

	# Check if moving
	if velocity.length() > 10:
		if animated_sprite.animation != "walk":
			animated_sprite.play("walk")
	else:
		if animated_sprite.animation != "idle":
			animated_sprite.play("idle")

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

	# Update animation based on movement
	_update_animation()

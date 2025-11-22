extends CharacterBody2D

@export var speed = 300.0
var player_type = "blue"

func _ready():
	set_player_type(player_type)

func set_player_type(type: String):
	player_type = type
	var sprite = $Sprite2D
	match type:
		"blue":
			sprite.modulate = Color(0.3, 0.5, 1.0)
		"red":
			sprite.modulate = Color(1.0, 0.3, 0.3)
		"green":
			sprite.modulate = Color(0.3, 1.0, 0.5)
		_:
			sprite.modulate = Color.WHITE

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

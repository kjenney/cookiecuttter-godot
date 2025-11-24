extends Area2D

@onready var speech_bubble = $SpeechBubble
@onready var speech_label = $SpeechBubble/Label

var player_nearby = false

func _ready():
	if speech_bubble:
		speech_bubble.visible = false
	# Connect signals if not already connected
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
	if not body_exited.is_connected(_on_body_exited):
		body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "Player":
		player_nearby = true
		show_speech_bubble()

func _on_body_exited(body):
	if body.name == "Player":
		player_nearby = false
		hide_speech_bubble()

func show_speech_bubble():
	if speech_bubble:
		speech_bubble.visible = true
	if speech_label:
		speech_label.text = "Hi, how are you?"

func hide_speech_bubble():
	if speech_bubble:
		speech_bubble.visible = false

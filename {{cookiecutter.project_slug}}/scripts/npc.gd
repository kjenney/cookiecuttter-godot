extends Area2D

@export var npc_message: String = "Hello!"

@onready var speech_bubble = $SpeechBubble
@onready var speech_label = $SpeechBubble/Label

var player_nearby = false

func _ready():
	print("[NPC] _ready called")
	print("[NPC] NPC message: '", npc_message, "'")

	# Set the label text from the exported variable
	if speech_label:
		speech_label.text = npc_message
		print("[NPC] Speech label text set to: '", speech_label.text, "'")

	if speech_bubble:
		speech_bubble.visible = false
		print("[NPC] Speech bubble initialized (hidden)")
	else:
		push_warning("[NPC] SpeechBubble node not found!")

	# Connect signals if not already connected
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
		print("[NPC] Connected body_entered signal")
	if not body_exited.is_connected(_on_body_exited):
		body_exited.connect(_on_body_exited)
		print("[NPC] Connected body_exited signal")

	print("[NPC] Collision layer: ", collision_layer, " | Collision mask: ", collision_mask)

func _on_body_entered(body):
	print("[NPC] Body entered: ", body.name, " (type: ", body.get_class(), ")")
	if body.name == "Player":
		print("[NPC] Player detected! Showing speech bubble.")
		player_nearby = true
		show_speech_bubble()
	else:
		print("[NPC] Body is not Player, ignoring.")

func _on_body_exited(body):
	print("[NPC] Body exited: ", body.name)
	if body.name == "Player":
		print("[NPC] Player left. Hiding speech bubble.")
		player_nearby = false
		hide_speech_bubble()

func show_speech_bubble():
	if speech_bubble:
		speech_bubble.visible = true
		print("[NPC] Speech bubble shown")
	else:
		push_warning("[NPC] Cannot show speech bubble - node not found!")
	if speech_label:
		# Text is already set in the scene file, just log it
		print("[NPC] Speech text: ", speech_label.text)

func hide_speech_bubble():
	if speech_bubble:
		speech_bubble.visible = false
		print("[NPC] Speech bubble hidden")

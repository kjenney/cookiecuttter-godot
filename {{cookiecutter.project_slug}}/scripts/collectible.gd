extends Area2D

func _on_body_entered(body):
	if body.name == "Player":
		# Trigger player collection animation
		if body.has_method("play_collect_animation"):
			body.play_collect_animation()

		# Add score
		var main_scene = get_tree().current_scene
		if main_scene.has_method("add_score"):
			main_scene.add_score(10)

		queue_free()

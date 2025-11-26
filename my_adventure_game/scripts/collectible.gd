extends Area2D

func _on_body_entered(body):
	if body.name == "Player":
		var main_scene = get_tree().current_scene
		if main_scene.has_method("add_score"):
			main_scene.add_score(10)
		queue_free()

extends CanvasLayer

func change_scene(target: String) -> void:
	$AnimationPlayer.play("fade_in")
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file(target)
	$AnimationPlayer.play("fade_out")

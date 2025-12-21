extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.play_music("game_complete")
	$AnimationPlayer.play("win")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	TransitionScene.change_scene("res://Scenes/tutorial_room.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()

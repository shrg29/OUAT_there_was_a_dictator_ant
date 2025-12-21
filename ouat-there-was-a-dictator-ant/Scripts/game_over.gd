extends TextureRect

func _ready() -> void:
	AudioManager.play_music("game_over")

func _on_start_pressed():
	get_tree().change_scene_to_file("res://Scenes/tutorial_room.tscn")


func _on_quit_pressed():
	TransitionScene.change_scene("res://Scenes/main_menu.tscn")

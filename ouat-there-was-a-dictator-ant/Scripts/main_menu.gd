extends TextureRect

func _ready():
	pass

#go to main scene
func _on_start_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_scene.tscn")

#quit
func _on_quit_pressed():
	get_tree().quit()

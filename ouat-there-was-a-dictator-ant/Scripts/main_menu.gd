extends Control

func _ready():
	$AnimatedSprite2D.play("default")
	await get_tree().process_frame
	$Container/Start.grab_focus()
	RecruitedAnts.visible = false

#go to main scene
func _on_start_pressed():
	TransitionScene.change_scene("res://Scenes/tutorial_room.tscn")

#quit
func _on_quit_pressed():
	get_tree().quit()

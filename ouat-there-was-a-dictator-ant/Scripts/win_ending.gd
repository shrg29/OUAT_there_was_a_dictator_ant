extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("win")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	TransitionScene.change_scene("res://Scenes/main_menu.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()

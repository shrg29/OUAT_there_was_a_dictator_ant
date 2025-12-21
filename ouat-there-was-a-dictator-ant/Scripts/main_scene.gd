extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	AudioManager.play_music("background_music")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GameState.recruited_ants.has("Anthony"):
		$Hole.visible = true
		$Hole/Area2D/CollisionShape2D.disabled = false


func _on_area_2d_area_entered(area: Area2D) -> void:
	World.start_game()

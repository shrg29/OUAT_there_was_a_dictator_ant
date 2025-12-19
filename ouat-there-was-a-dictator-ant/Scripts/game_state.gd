extends Node

var recruited_ants: Array[String] = []

var failed_game: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func recruited_ant(name: String) -> Array[String]:
	recruited_ants.push_back(name)
	return recruited_ants

extends Node2D

@export var spawn_N = Vector2(930, 130)
@export var spawn_E = Vector2(1790, 535)
@export var spawn_S = Vector2(930, 930)
@export var spawn_W = Vector2(180, 535)

func _ready() -> void:
	match World.came_from:
		"N": $player.position = spawn_N
		"E": $player.position = spawn_E
		"S": $player.position = spawn_S
		"W": $player.position = spawn_W
	

func _on_north_area_entered(area: Area2D) -> void:
	World.load_room("N")


func _on_south_area_entered(area: Area2D) -> void:
	World.load_room("S")


func _on_east_area_entered(area: Area2D) -> void:
	World.load_room("E")


func _on_west_area_entered(area: Area2D) -> void:
	World.load_room("W")

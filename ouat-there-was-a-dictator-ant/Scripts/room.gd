extends Node2D


func _on_north_area_entered(area: Area2D) -> void:
	World.load_room("N")


func _on_south_area_entered(area: Area2D) -> void:
	World.load_room("S")


func _on_east_area_entered(area: Area2D) -> void:
	World.load_room("E")


func _on_west_area_entered(area: Area2D) -> void:
	World.load_room("W")

extends Node2D

var north_room = "res://Scenes/level_example.tscn"
var south_room = "res://Scenes/level_example.tscn"
var east_room = "res://Scenes/level_example.tscn"
var west_room = "res://Scenes/level_example.tscn"


func _on_north_area_entered(area: Area2D) -> void:
	print("entered")
	TransitionScene.change_scene(north_room)


func _on_south_area_entered(area: Area2D) -> void:
	TransitionScene.change_scene(south_room)


func _on_east_area_entered(area: Area2D) -> void:
	TransitionScene.change_scene(east_room)


func _on_west_area_entered(area: Area2D) -> void:
	TransitionScene.change_scene(west_room)

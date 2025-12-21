extends Node2D



@export var map_transparency = 0.5
@onready var mini_map = $minimap

func generate_mini_map():
	AntHillGenerator.map_transparency = self.map_transparency
	mini_map.texture = AntHillGenerator.get_mini_map()
	


func _ready() -> void:
	generate_mini_map()

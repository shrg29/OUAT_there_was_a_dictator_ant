extends Node2D



@export var map_transparency = 0.5
@onready var mini_map = $minimap
@onready var game_timer = $GameTimer
@onready var timer_label = $TimerLabel

var time_left: int

func generate_mini_map():
	AntHillGenerator.map_transparency = self.map_transparency
	mini_map.texture = AntHillGenerator.get_mini_map()
	


func _ready() -> void:
	generate_mini_map()
	if timer_label:
		timer_label.text = "Time: %d" % time_left
	game_timer.start()

func _process(delta):
	# optional: update label every frame if you want live countdown
	if timer_label:
		var remaining = int(game_timer.time_left)
		timer_label.text = "Time: %d" % remaining


func _on_game_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://Scenes/game_over.tscn")

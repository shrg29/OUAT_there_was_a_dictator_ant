extends Node2D

var npc_scene = preload("res://Scenes/ant_npc.tscn")

var dialogue_anton: DialogueResource = preload("res://Dialogues/anton.dialogue")
var dialogue_anthony: DialogueResource = preload("res://Dialogues/anthony.dialogue")
var dialogue_antonia: DialogueResource = preload("res://Dialogues/antonia.dialogue")


func _ready() -> void:
	spawn_npc("Anthony", dialogue_anthony, 100, 100)
	spawn_npc("Anton", dialogue_anton, 1000, 1000)
	spawn_npc("Antonia", dialogue_antonia, 1000, 100)


func _process(delta: float) -> void:
	pass


func spawn_npc(npc_name: String, dialogue: DialogueResource, coordinate_x: float, coordinate_y: float):
	var npc: Node2D = npc_scene.instantiate()
	npc.position = Vector2(coordinate_x, coordinate_y)
	npc.npc_name = npc_name
	npc.npc_dialogue = dialogue
	add_child(npc)

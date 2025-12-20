extends Node2D

var npc_scene = preload("res://Scenes/ant_npc.tscn")

var dialogue_anton: DialogueResource = preload("res://Dialogues/anton.dialogue")
var dialogue_anthony: DialogueResource = preload("res://Dialogues/anthony.dialogue")
var dialogue_antonia: DialogueResource = preload("res://Dialogues/antonia.dialogue")
var dialogue_kasantra: DialogueResource = preload("res://Dialogues/kasantra.dialogue")
var dialogue_samantha: DialogueResource = preload("res://Dialogues/Samantha.dialogue")
var dialogue_antdrew: DialogueResource = preload("res://Dialogues/antdrew.dialogue")
var dialogue_queen: DialogueResource = preload("res://Dialogues/queen.dialogue")


func _ready() -> void:
	spawn_npc("The Queen", dialogue_queen, 100, 100, true)
	spawn_npc("Samantha", dialogue_samantha, 1000, 1000, true)
	spawn_npc("Antdrew", dialogue_antdrew, 1000, 100, true)
	spawn_npc("Kasantra", dialogue_kasantra, 100, 1000, true)


func _process(delta: float) -> void:
	pass


func spawn_npc(npc_name: String, dialogue: DialogueResource, coordinate_x: float, coordinate_y: float, interactable: bool):
	var npc: Node2D = npc_scene.instantiate()
	npc.position = Vector2(coordinate_x, coordinate_y)
	npc.npc_name = npc_name
	npc.npc_dialogue = dialogue
	npc.is_interactable = interactable
	add_child(npc)

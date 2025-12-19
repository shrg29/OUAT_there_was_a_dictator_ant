extends Node2D

var npc_scene = preload("res://Scenes/ant_npc.tscn")

var test_dialogue = preload("res://Dialogues/testing.dialogue")
var dialogue_anthony = preload("res://Dialogues/anthony.dialogue")



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_npc("Anthony", dialogue_anthony, 100, 100)
	#DialogueManager.show_dialogue_balloon(test_dialogue_two)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func spawn_npc(npc_name: String, dialogue: Resource, coordinate_x: float, coordinate_y: float):
	var npc: Node2D = npc_scene.instantiate()
	npc.position = Vector2(coordinate_x, coordinate_y)
	npc.npc_name = npc_name
	npc.npc_dialogue = dialogue
	add_child(npc)

extends Node2D


var test_dialogue_one = preload("res://Dialogues/testing.dialogue")
var test_dialogue_two = preload("res://Dialogues/other_test.dialogue")



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DialogueManager.show_dialogue_balloon(test_dialogue_two)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

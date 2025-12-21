extends Node2D


@export var print_mode: bool = true

@export var npc_name: String = "Antonia"
@export var npc_dialogue: DialogueResource = preload("res://Dialogues/antonia.dialogue")

@export var is_interactable: bool = true
@onready var marker: Sprite2D = $Marker
@onready var interaction_area = $InteractionArea

signal interactable_entered(npc)
signal interactable_exited(npc)


func _ready() -> void:
	$AnimationPlayer.play("idle")
	marker.visible = false
	
	add_to_group("npc") # identifier for interactable npcs
	
	# connecting signals through code for consistency
	interaction_area.body_entered.connect(_on_body_entered)
	interaction_area.body_exited.connect(_on_body_exited)
	
	await get_tree().process_frame
	for p in get_tree().get_nodes_in_group("player"):
		p.inform_current_interactable.connect(_on_becoming_target)


func _on_body_entered(body):
	if body.is_in_group("player"):
		interactable_entered.emit(self)
		if print_mode:
			print(npc_name, ": interaction enabled signal emitted")


func _on_body_exited(body):
	if body.is_in_group("player"):
		interactable_exited.emit(self)
		if print_mode:
			print(npc_name, ": interaction disabled signal emitted")


func _on_becoming_target(target):
	if self == target:
		if print_mode:
			print(npc_name, " is the current target")
		marker.visible = true
	else:
		if print_mode:
			print(npc_name, " is not the current target")
		marker.visible = false

func interact():
	if print_mode:
		print("Interacting with: ", npc_name)
	start_dialogue()


func start_dialogue():
	if print_mode:
		print("Starting Dialogue with: ", npc_name)
	DialogueManager.show_dialogue_balloon(npc_dialogue, "start", [])

extends CharacterBody2D

@export var print_mode: bool = true

@export var npc_name: String = ""
@export var npc_dialogue: Resource

@export var demand_item: Resource
@export var demand_amount: int

@onready var interaction_area = $InteractionArea

signal interactable_entered(npc)
signal interactable_exited(npc)


func _ready():
	
	add_to_group("npc") # identifier for interactable npcs
	
	# connecting signals through code for consistency
	interaction_area.body_entered.connect(_on_body_entered)
	interaction_area.body_exited.connect(_on_body_exited)
	
	interact() # testing purposes


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


func interact():
	if print_mode:
		print("interacting with: ", npc_name)
	start_dialogue()


func start_dialogue():
	if print_mode:
		print("Starting Dialogue with: ", npc_name)
	DialogueManager.show_dialogue_balloon(npc_dialogue, "start", [])

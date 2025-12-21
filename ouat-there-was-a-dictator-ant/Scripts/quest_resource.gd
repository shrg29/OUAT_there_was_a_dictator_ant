extends Resource
class_name Quest

@export var quest_name: String
@export var description: String
@export var npc: String

@export var target_item: ItemResource
@export var required_amount: int

var current_amount: int = 0
var is_completed: bool = false

func add_progress(item: ItemResource, amount: int):
	if is_completed:
		return

	if item != target_item:
		return

	current_amount += amount
	if current_amount >= required_amount:
		current_amount = required_amount
		is_completed = true

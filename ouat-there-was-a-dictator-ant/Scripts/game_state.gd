extends Node


var print_mode: bool = true

enum state {TALKING, WALKING}
var current_state: state = state.WALKING

var recruited_ants: Array[String] = ["Player"] # Array holding all successfully recruited ants
var held_items: Array[Resource] = [] # Array holding all items we are currently carrying

enum anton_opinion {HATE, FINE}
var anton_current_opinion: anton_opinion = anton_opinion.FINE

var failed_game: bool = false # Game over check



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


#region Inventory

func update_item_display():
	if held_items.size() <= recruited_ants.size():
		var ant_index = 0
		for ant in recruited_ants:
			if ant_index <= held_items.size() - 1:
				# TODO: actually make visuals
				if print_mode:
					print(ant, " is holding ", held_items[ant_index])
			else:
				# TODO: actually make visuals
				if print_mode:
					print(ant, " does not have an item to hold")
			ant_index = ant_index + 1
	else:
		if print_mode:
			print("Error: Too many items to display")


func pick_up_item(item: Resource):
	if held_items.size() < recruited_ants.size():
		held_items.push_back(item)
		update_item_display()
	else:
		if print_mode:
			print("Holding too many items")


func give_item(gift: Resource, amount: int):
	# TODO: (maybe) give items to npc - might be handled elsewhere
	var matching_items: Array[Resource] = []
	for item in held_items:
		if item == gift:
			matching_items.push_back(item)
	if matching_items.size() < amount:
		if print_mode:
			# TODO: (maybe) change it, so it gives all available items instead?
			print("Trying to give too many items")
	else:
		var to_remove: int = amount
		var removed_count: int = 0
		for i in range(held_items.size() - 1, -1, -1):
			if held_items[i] == gift and removed_count < to_remove:
				held_items.remove_at(i)
				removed_count += 1
	update_item_display()


func drop_item(location: Vector2):
	# TODO: function to drop the item on the ground at "location"
	held_items.remove_at(0)
	update_item_display()
#endregion




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func recruit_ant(name: String) -> Array[String]:
	recruited_ants.push_back(name)
	print("Recruited ANts: ", recruited_ants)
	return recruited_ants

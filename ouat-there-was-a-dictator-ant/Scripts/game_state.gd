extends Node


var print_mode: bool = false

#region Item Preloads
var beer_item: ItemResource = preload("res://Resource/Item Resources/beer.tres")
var coin_item: ItemResource = preload("res://Resource/Item Resources/coin.tres")
var stick_item: ItemResource = preload("res://Resource/Item Resources/stick.tres")
var stone_item: ItemResource = preload("res://Resource/Item Resources/stone.tres")
var water_item: ItemResource = preload("res://Resource/Item Resources/water.tres")
var anthony_quest: Quest = preload("res://Resource/Quests/anthony_quest.tres")
var antonia_quest: Quest = preload("res://Resource/Quests/antonia_quest.tres")
var kasantra_quest: Quest = preload("res://Resource/Quests/kasantra_quest.tres")
var kasantra_quest_two: Quest = preload("res://Resource/Quests/kasantra_quest_two.tres")
var samanta_quest: Quest = preload("res://Resource/Quests/samanta_quest.tres")
var antamaria_quest: Quest = preload("res://Resource/Quests/antamaria_quest.tres")
#endregion

#region Ant-Speech Pitch values
var low: float = 0.5
var high: float = 0.9
#endregion

enum state {TALKING, WALKING}
var current_state: state = state.WALKING

var recruited_ants: Array[String] # Array holding all successfully recruited ants
var held_items: Array[ItemResource] # Array holding all items we are currently carrying

signal item_update(valid: bool)

#region Specific Ants

var anthony_demand_item: ItemResource = stick_item
var anthony_demand_amount: int = 1
var has_met_anthony: bool = false

var has_met_antonia: bool = false
var got_antonia_quest: bool = false

var has_met_kasantra: bool = false
var kasantra_first_quest_complete: bool = false
var kasantra_demand_item: ItemResource = water_item
var kasantra_demand_amount: int = 6
var kasantra_second_item: ItemResource = stick_item
var kasantra_second_amount: int = 1

var has_met_samanta: bool = false
var samanta_demand_item: ItemResource = beer_item
var samanta_demand_amount: int = 1

var has_met_antdrew: bool = false
var recieved_beer: bool = false

var has_met_queen: bool = false

var has_met_anta:bool = false
var anta_demand_item: ItemResource = coin_item
var anta_demand_amount: int = 1

enum anton_opinion {HATE, FINE}
var anton_current_opinion: anton_opinion = anton_opinion.FINE
var anton_demand_item: ItemResource = water_item
var anton_demand_amount: int = 2



#endregion

var failed_game: bool = false # Game over check
@export var ant_number_goal: int = 6 # How many ants (including player) should there be to win?




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	recruited_ants.push_back("Player")
	update_item_display()
	pass # Replace with function body.


#region Inventory

func update_item_display():
	if held_items.size() <= recruited_ants.size():
		var ant_index = 0
		for ant in recruited_ants:
			if ant_index <= held_items.size() - 1:
				# TODO: actually make visuals
				if print_mode:
					print(ant, " is holding ", held_items[ant_index].item_name)
			else:
				# TODO: actually make visuals
				if print_mode:
					print(ant, " does not have an item to hold")
			ant_index = ant_index + 1
		#if held_items.size() > 0:
			#blablainstance of this item.set_type(held_items[0])
	else:
		if print_mode:
			print("Error: Too many items to display")
	item_update.emit(held_items.size() > 0)
	
	for i in held_items:
		print(i.item_name)


func pick_up_item(item: ItemResource):
	if held_items.size() < recruited_ants.size():
		held_items.push_back(item)
		AudioManager.play_sfx("item_collected")
		update_item_display()
	else:
		if print_mode:
			print("Holding too many items")


func count_item(item: ItemResource) -> int:
	var matching_items: Array[ItemResource] = []
	for i in held_items:
		if i == item:
			matching_items.push_back(item)
	return matching_items.size()


func give_item(gift: ItemResource, amount: int):
	# TODO: (maybe) give items to npc - might be handled elsewhere
	if count_item(gift) < amount:
		# TODO: (maybe) change it, so it gives all available items instead?
		if print_mode:
			print("Error: Trying to give too many items")
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
	if held_items.size() == 0 : return #if no item return
	var dropped_item = held_items.pop_at(0) #pop the item out of the array
	
	#print("Dropping item: ", dropped_item.item_name if dropped_item else "NULL")
	#print("Item texture: ", dropped_item.item_texture if dropped_item else "NULL")
	
	var item_instance_preload = preload("res://Scenes/item_instance.tscn") #load the instance
	var item_instance = item_instance_preload.instantiate()
	
	item_instance.global_position = location #set up the location no clue if this actually works
	
	get_tree().root.get_child(0).add_child(item_instance)
	print("hi: ", get_tree().root.get_child(0).name)
	
	item_instance.set_type(dropped_item)
	print("droped: ", dropped_item.item_name)
	item_instance.visible = true
	
	AudioManager.play_sfx("drop")
	update_item_display()
#endregion




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func recruit_ant(name: String) -> Array[String]:
	recruited_ants.push_back(name)
	if print_mode:
		print("Recruited Ants: ", recruited_ants)
	RecruitedAnts.update_ant_display(name)
	
	if recruited_ants.size() >= ant_number_goal:
		end_game()
		
	return recruited_ants


func end_game():
	if failed_game == true:
		TransitionScene.change_scene("res://Scenes/game_over.tscn")
	else:
		TransitionScene.change_scene("res://Scenes/win_ending.tscn")

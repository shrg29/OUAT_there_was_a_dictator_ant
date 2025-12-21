extends CanvasLayer

var screen_index: int = 1

@onready var screen_one = $HBoxContainer/Control/SubViewportContainer/screen_one
@onready var screen_two = $HBoxContainer/Control2/SubViewportContainer/screen_two
@onready var screen_three = $HBoxContainer/Control3/SubViewportContainer/screen_three
@onready var screen_four = $HBoxContainer/Control4/SubViewportContainer/screen_four
@onready var screen_five = $HBoxContainer/Control5/SubViewportContainer/screen_five

@onready var anthony = preload("res://Scenes/npc/npc_3.tscn")
@onready var antdrew = preload("res://Scenes/npc/npc_2.tscn")
@onready var antonia = preload("res://Scenes/npc/npc_3.tscn")
@onready var anta = preload("res://Scenes/npc/npc_4.tscn")
@onready var samanta = preload("res://Scenes/npc/npc_carpenter.tscn")
@onready var kasantra = preload("res://Scenes/npc/npc_nursery.tscn")

@onready var item_one = $HBoxContainer/Control/SubViewportContainer/screen_one/item_one
@onready var item_two = $HBoxContainer/Control2/SubViewportContainer/screen_two/item_two
@onready var item_three = $HBoxContainer/Control3/SubViewportContainer/screen_three/item_three
@onready var item_four = $HBoxContainer/Control4/SubViewportContainer/screen_four/item_four
@onready var item_five = $HBoxContainer/Control5/SubViewportContainer/screen_five/item_five


func _ready() -> void:
	await get_tree().process_frame
	GameState.item_update.connect(update_item_holder)
	pass


func update_ant_display(name: String):
	await get_tree().process_frame
	var new_screen
	screen_index = GameState.recruited_ants.size() + 1
	match screen_index:
		1:
			new_screen = screen_one
		2:
			new_screen = screen_two
		3:
			new_screen = screen_three
		4:
			new_screen = screen_four
		5:
			new_screen = screen_five
	print("New Screen: ", str(new_screen))
	
	match name:
		"Anthony":
			var scene = anthony.instantiate()
			scene.position = Vector2(150,150)
			new_screen.add_child(scene)
		"Antdrew":
			var scene = antdrew.instantiate()
			scene.position = Vector2(150,150)
			new_screen.add_child(scene)
		"Antonia":
			var scene = antonia.instantiate()
			scene.position = Vector2(150,150)
			new_screen.add_child(scene)
		"Anta Maria":
			var scene = anta.instantiate()
			scene.position = Vector2(150,150)
			new_screen.add_child(scene)
		"Samanta":
			var scene = samanta.instantiate()
			scene.position = Vector2(150,150)
			new_screen.add_child(scene)
		"Kasantra":
			var scene = kasantra.instantiate()
			scene.position = Vector2(150,150)
			new_screen.add_child(scene)
			pass

func update_item_holder(valid: bool):
	await get_tree().process_frame
	if valid == true:
		if GameState.held_items.size() >= 6:
			item_five.texture = GameState.held_items[5].item_texture
		else:
			item_five.texture = null
		if GameState.held_items.size() >= 5:
			item_four.texture = GameState.held_items[4].item_texture
		else:
			item_four.texture = null
		if GameState.held_items.size() >= 4:
			item_three.texture = GameState.held_items[3].item_texture
		else:
			item_three.texture = null
		if GameState.held_items.size() >= 3:
			item_two.texture = GameState.held_items[2].item_texture
		else:
			item_two.texture = null
		if GameState.held_items.size() >= 2:
			item_one.texture = GameState.held_items[1].item_texture
		else:
			item_one.texture = null

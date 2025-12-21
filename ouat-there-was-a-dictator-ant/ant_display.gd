extends Control

@onready var anthony = preload("res://Scenes/npc/npc_1.tscn")
@onready var antdrew = preload("res://Scenes/npc/npc_2.tscn")
@onready var antonia = preload("res://Scenes/npc/npc_3.tscn")
@onready var anta = preload("res://Scenes/npc/npc_4.tscn")
@onready var samanta = preload("res://Scenes/npc/npc_carpenter.tscn")
@onready var kasantra = preload("res://Scenes/npc/npc_nursery.tscn")

@onready var new_scene = $CenterContainer
@onready var item = $itemdisplay

#Display the sprite of the ant depending on the name that we are giving in the other scene
func display_ant(scene_type):
	var scene = scene_type.instantiate()
	scene.position = Vector2(110,110)
	new_scene.add_child(scene)

#Display item through texture
func display_item(texture):
	item.texture = texture

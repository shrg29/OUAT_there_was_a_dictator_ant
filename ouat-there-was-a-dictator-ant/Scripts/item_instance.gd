extends Node2D

var print_mode: bool = false

@export var item_type: ItemResource = null
@onready var item_title: String
@onready var item_image_holder = $Sprite2D
@onready var pickup_area = $PickupArea


signal item_area_entered(item)
signal item_area_exited(item)


func _ready() -> void:
	
	add_to_group("item")
	
	# connecting signals through code for consistency
	pickup_area.body_entered.connect(_on_body_entered)
	pickup_area.body_exited.connect(_on_body_exited)
	
	await get_tree().process_frame
	for p in get_tree().get_nodes_in_group("player"):
		p.inform_current_item.connect(_on_becoming_target)
	
	if item_type != null:
		set_type(item_type)


func set_type(type: ItemResource):
	item_type = type
	item_title = item_type.item_name
	item_image_holder.texture = item_type.item_texture


func _on_body_entered(body):
	if body.is_in_group("player"):
		item_area_entered.emit(self)
		if print_mode:
			print("player entered")


func _on_body_exited(body):
	if body.is_in_group("player"):
		item_area_exited.emit(self)
		if print_mode:
			print("player exited")


func _on_becoming_target(target):
	if self == target:
		if print_mode:
			print(item_title, " is the current target")
		# TODO: Add visual indicator for interaction
	else:
		if print_mode:
			print(item_title, " is not the current target")
		# TODO: Remove visual indicator for interaction


func interact():
	if print_mode:
		print("Picking up: ", item_title)
	GameState.pick_up_item(item_type)
	queue_free()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

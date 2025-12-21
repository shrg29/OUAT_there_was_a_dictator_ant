extends CharacterBody2D


#region Interaction variables
var nearby_interactables = []  # Track all nearby NPCs
var current_interactable: Node2D = null

signal inform_current_interactable(npc)
#endregion

#region Item variables
var nearby_items = []  # Track all nearby NPCs
var current_item: Node2D = null

@onready var item_holder: Sprite2D = $ItemHolder

signal inform_current_item(item)
#endregion

#sound
@onready var audio_player = AudioStreamPlayer.new()
#region SFX files
#var sound_attack_1 = preload("res://assets/SFX/player noises/attack_blub_voice.wav") 
#var sound_attack_2 = preload("res://assets/SFX/player noises/attack_blub_voice_2.wav") 
#var sound_attack_3 = preload("res://assets/SFX/player noises/attack_blub.wav")
#var sound_attack_4 = preload("res://assets/SFX/player noises/attack_blub_2.wav")
#var sound_attacks = [sound_attack_3, sound_attack_4]
#var sound_steps = preload("res://assets/SFX/player noises/steps.wav")
#var sound_died = preload("res://assets/SFX/player noises/died.wav")
#var sound_hit = preload("res://assets/SFX/player noises/Autsch.wav")
#var sound_joy = preload("res://assets/SFX/player noises/wahahuu.wav")
#endregion

@export var speed: int = 600

#animations
@onready var animations = $main_ant/AnimationPlayer
var stop_animations = false
#cardinal directions:
#region Direction Ranges
var E = Vector2(-PI/4, PI/4)
var N = Vector2(PI/4, 3*PI/4)
var W = Vector2(3*PI/4, -3*PI/4)  # wrapped across π
var S = Vector2(-3*PI/4, -PI/4)

#endregion

#region inputs
var walk_left = "walk_left"
var walk_right = "walk_right"
var walk_up = "walk_up"
var walk_down = "walk_down"
var attack = "attack"
#endregion


@onready var character = $main_ant
var direction = "down"
var move_direction
var last_direction = Vector2(1, 1) #to see where we looked at last and attack in that position if we stand still




var isHurt = false


func _ready() -> void:
	add_to_group("player")
	item_holder.visible = true
	
	await get_tree().process_frame
	
	# Connecting to existing and later NPCs & items
	for npc in get_tree().get_nodes_in_group("npc"):
		_connect_to_npc(npc)
	
	for item in get_tree().get_nodes_in_group("item"):
		_connect_to_item(item)
	
	get_tree().node_added.connect(_on_node_added)
	
	GameState.item_update.connect(update_item_holder)


#region Interaction
func _on_node_added(node): # newly added NPCs
	if node.is_in_group("npc"):
		_connect_to_npc(node)
	elif node.is_in_group("item"):
		_connect_to_item(node)


func _connect_to_npc(npc): # Connecting to NPC signals
	if not npc.interactable_entered.is_connected(_on_interactable_entered):
		npc.interactable_entered.connect(_on_interactable_entered)
		npc.interactable_exited.connect(_on_interactable_exited)


func _on_interactable_entered(npc): # Tracking nearby interactable NPCs
	if npc not in nearby_interactables and npc.is_interactable == true:
		nearby_interactables.append(npc)
	_update_current_interactable()


func _on_interactable_exited(npc): # Removing NPCs upon exiting interaction range
	nearby_interactables.erase(npc)
	_update_current_interactable()


func _update_current_interactable(): # Keeping current interactable clean
	if nearby_interactables.is_empty():
		current_interactable = null
	else:
		current_interactable = _get_closest_interactable()
	inform_current_interactable.emit(current_interactable)


func _get_closest_interactable(): # setting closest npc as current interactable
	var closest = nearby_interactables[0]
	var closest_dist = global_position.distance_to(closest.global_position)
	
	for npc in nearby_interactables:
		var dist = global_position.distance_to(npc.global_position)
		if dist < closest_dist:
			closest = npc
			closest_dist = dist
	
	return closest
#endregion


#region Item Pickup
func _connect_to_item(item): # Connecting to item signals
	if not item.item_area_entered.is_connected(_on_item_area_entered):
		item.item_area_entered.connect(_on_item_area_entered)
		item.item_area_exited.connect(_on_item_area_exited)


func _on_item_area_entered(item): # Tracking nearby items
	if item not in nearby_items:
		nearby_items.append(item)
	_update_current_item()


func _on_item_area_exited(item): # Removing items upon exiting interaction range
	nearby_items.erase(item)
	_update_current_item()


func _update_current_item(): # Keeping current item clean
	if nearby_items.is_empty():
		current_item = null
	else:
		current_item = _get_closest_item()
	inform_current_item.emit(current_item)


func _get_closest_item(): # setting closest item as current interactable
	var closest = nearby_items[0]
	var closest_dist = global_position.distance_to(closest.global_position)
	
	for item in nearby_items:
		var dist = global_position.distance_to(item.global_position)
		if dist < closest_dist:
			closest = item
			closest_dist = dist
	
	return closest


func update_item_holder(valid: bool):
	if valid == true:
		item_holder.texture = GameState.held_items[0].item_texture
		item_holder.visible = true
	else:
		item_holder.visible = true
		item_holder.texture = null
#endregion

func handleInput():
	move_direction = Input.get_vector(walk_left, walk_right, walk_up, walk_down)
	velocity = move_direction.normalized()*speed
	
	if Input.is_action_just_pressed("interact"):
		if current_interactable: # only interact if there is a current_interactable npc
			if GameState.current_state != GameState.state.TALKING: # only interact if not already talking
				current_interactable.interact()
				GameState.current_state = GameState.state.TALKING
	
	if Input.is_action_just_pressed("drop_item"):
		if GameState.current_state != GameState.state.TALKING: # only pickup if not in dialogue
			if current_item: # only pickup if there is a current item
				current_item.interact()
			elif GameState.held_items.size() >= 1:
				GameState.drop_item(global_position)


func _physics_process(delta):
	handleInput()
	if GameState.current_state == GameState.state.WALKING:
		updateAnimation()
		move_and_slide()
	



#region animation
func angle_in_range(angle: float, range: Vector2) -> bool:
	var a = wrapf(angle, -PI, PI)
	var a1 = wrapf(range.x, -PI, PI)
	var a2 = wrapf(range.y, -PI, PI)

	# Normal case (no wrap)
	if a1 <= a2:
		return a >= a1 and a <= a2

	# Wrapped case (example: 3*PI/4, -3*PI/4)
	return a >= a1 or a <= a2




func updateAnimation():
	if stop_animations:
		return
	
	
	if velocity.length() > 0 :# update last_direction
		last_direction = velocity.normalized()

	
	#idle
	if velocity.length() == 0:
		if last_direction == Vector2(0,0): #did not walk yet
			character.scale.x = 1
			animations.play("front_idle")
		#down = front
		if angle_in_range(last_direction.angle(), N):
			character.scale.x = 1
			animations.play("front_idle")
		#up = back
		if angle_in_range(last_direction.angle(), S):
			character.scale.x = 1
			animations.play("back_idle")
		#left
		if angle_in_range(last_direction.angle(), W):
			character.scale.x = -1
			animations.play("side_idle")
		#right
		if angle_in_range(last_direction.angle(), E):
			character.scale.x = 1
			animations.play("side_idle")
		return
	#print(move_direction)

	#walking
	if velocity.length() > 0:
		# Use same range detection as idle
		if angle_in_range(last_direction.angle(), N):
			character.scale.x = 1
			animations.play("front_walk")
		elif angle_in_range(last_direction.angle(), S):
			character.scale.x = 1
			animations.play("back_walk")
		elif angle_in_range(last_direction.angle(), W):
			character.scale.x = -1
			animations.play("side_walk")
		elif angle_in_range(last_direction.angle(), E):
			character.scale.x = 1
			animations.play("side_walk")


#endregion


 
#region signals



#endregion

extends CharacterBody2D





#sound
@onready var audio_player = $AudioStreamPlayer2D
#region SFX files
@export var audio_stuff: Resource
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

@export var speed: int = 250

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
	pass


func handleInput():
	move_direction = Input.get_vector(walk_left, walk_right, walk_up, walk_down)
	velocity = move_direction.normalized()*speed


func _physics_process(delta):
	handleInput()
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

extends Node2D



var world_grid
var nurseries = []
var foods = []
var carpenters = []
var queens = []
var waters = []
var coins = []
var one_door_tunnels = []
var two_door_tunnels  = []# maybe another way to store them or note the order
var three_door_tunnels = []
var four_door_tunnels = []
var starts = []
var start_room
var came_from

var current_room
enum dir{
	N,
	S,
	E,
	W
}

var adjacent_rooms = {
	dir.N:"",
	dir.S:"",
	dir.E:"",
	dir.W:"",
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	world_grid = AntHillGenerator.get_grid()
	start_room = AntHillGenerator.start_room
	current_room = start_room
	fill_room_arrays()
	
	assign_rooms()
	
	print_grid()
	
	find_adjacent_rooms()
	print("start room at: ", start_room.x, ", ", start_room.y)
	


func start_game():
	var hudquests = load("res://Scenes/questHUD.tscn").instantiate()
	var pause_menu = load("res://Scenes/pause_menu.tscn").instantiate()
	get_tree().get_root().add_child(pause_menu)
	get_tree().get_root().add_child(hudquests)
	pause_menu.z_index = 1000 
	TransitionScene.change_scene(start_room.scene)
	RecruitedAnts.visible = true


func print_grid():
	print("Grid Map (Scenes):")
	for y in range(world_grid.y):
		var row = ""
		for x in range(world_grid.x):
			var cell = world_grid.get_cell(x, y)
			if cell.scene == null:
				row += "X "
			elif "1_doors" in cell.scene:
				row += "1 "
			elif "2_doors" in cell.scene:
				row += "2 "
			elif "3_doors" in cell.scene:
				row += "3 "
			elif "4_doors" in cell.scene:
				row += "4 "
			else:
				row += "? "
		print(row)

func fill_room_arrays():
	#-----------------one door in following order: N, E, S, W
	one_door_tunnels.append("res://Scenes/rooms/tunnels/1_doors_N.tscn")
	one_door_tunnels.append("res://Scenes/rooms/tunnels/1_doors_E.tscn")
	one_door_tunnels.append("res://Scenes/rooms/tunnels/1_doors_S.tscn")
	one_door_tunnels.append("res://Scenes/rooms/tunnels/1_doors_W.tscn")
	
	#-------------- two doors in following order: NE, NS, NW, SE, SW, EW
	two_door_tunnels.append("res://Scenes/rooms/tunnels/2_doors_NE.tscn")
	two_door_tunnels.append("res://Scenes/rooms/tunnels/2_doors_NS.tscn")
	two_door_tunnels.append("res://Scenes/rooms/tunnels/2_doors_NW.tscn")
	two_door_tunnels.append("res://Scenes/rooms/tunnels/2_doors_SE.tscn")
	two_door_tunnels.append("res://Scenes/rooms/tunnels/2_doors_SW.tscn")
	two_door_tunnels.append("res://Scenes/rooms/tunnels/2_doors_EW.tscn")
	
	#----------------3 rooms in following order: N, E, S, W
	three_door_tunnels.append("res://Scenes/rooms/tunnels/3_doors_N.tscn")
	three_door_tunnels.append("res://Scenes/rooms/tunnels/3_doors_E.tscn")
	three_door_tunnels.append("res://Scenes/rooms/tunnels/3_doors_S.tscn")
	three_door_tunnels.append("res://Scenes/rooms/tunnels/3_doors_W.tscn")
	
	four_door_tunnels.append("res://Scenes/rooms/tunnels/4_doors.tscn")
	
	
	#the rest are basically one door tunnels
	nurseries.append("res://Scenes/rooms/nurseries/nursery_N.tscn")
	nurseries.append("res://Scenes/rooms/nurseries/nursery_E.tscn")
	nurseries.append("res://Scenes/rooms/nurseries/nursery_S.tscn")
	nurseries.append("res://Scenes/rooms/nurseries/nursery_W.tscn")
	
	
	foods.append("res://Scenes/rooms/foods/food_N.tscn")
	foods.append("res://Scenes/rooms/foods/food_E.tscn")
	foods.append("res://Scenes/rooms/foods/food_S.tscn")
	foods.append("res://Scenes/rooms/foods/food_W.tscn")
	
	
	
	carpenters.append("res://Scenes/rooms/carpenters/carpenter_N.tscn")
	carpenters.append("res://Scenes/rooms/carpenters/carpenter_E.tscn")
	carpenters.append("res://Scenes/rooms/carpenters/carpenter_S.tscn")
	carpenters.append("res://Scenes/rooms/carpenters/carpenter_W.tscn")
	
	
	
	queens.append("res://Scenes/rooms/queens/queen_N.tscn")
	queens.append("res://Scenes/rooms/queens/queen_E.tscn")
	queens.append("res://Scenes/rooms/queens/queen_S.tscn")
	queens.append("res://Scenes/rooms/queens/queen_W.tscn")
	
	
	
	waters.append("res://Scenes/rooms/waters/water_N.tscn")
	waters.append("res://Scenes/rooms/waters/water_E.tscn")
	waters.append("res://Scenes/rooms/waters/water_S.tscn")
	waters.append("res://Scenes/rooms/waters/water_W.tscn")

	# order: 3N, 3E, 3S, 3W, 4
	starts.append("res://Scenes/rooms/starts/start_3_doors_N.tscn")
	starts.append("res://Scenes/rooms/starts/start_3_doors_E.tscn")
	starts.append("res://Scenes/rooms/starts/start_3_doors_S.tscn")
	starts.append("res://Scenes/rooms/starts/start_3_doors_W.tscn")
	starts.append("res://Scenes/rooms/starts/start_4_doors.tscn")
	
	coins.append("res://Scenes/rooms/coins/coin_N.tscn")
	coins.append("res://Scenes/rooms/coins/coin_E.tscn")
	coins.append("res://Scenes/rooms/coins/coin_S.tscn")
	coins.append("res://Scenes/rooms/coins/coin_W.tscn")

func find_adjacent_rooms():
	adjacent_rooms[dir.N] = null
	adjacent_rooms[dir.S] = null
	adjacent_rooms[dir.E] = null
	adjacent_rooms[dir.W] = null
	
	if current_room.y - 1 >= 0: # North/Up
		var N = world_grid.get_cell(current_room.x, current_room.y - 1)
		if N.type != AntHillGenerator.tile_type.WALL && N.type != AntHillGenerator.tile_type.NONE:
			adjacent_rooms[dir.N] = N

	if current_room.y + 1 < world_grid.y: # South/Down
		var S = world_grid.get_cell(current_room.x, current_room.y + 1)
		if S.type != AntHillGenerator.tile_type.WALL && S.type != AntHillGenerator.tile_type.NONE:
			adjacent_rooms[dir.S] = S

	if current_room.x + 1 < world_grid.x: # East/Right
		var E = world_grid.get_cell(current_room.x + 1, current_room.y)
		if E.type != AntHillGenerator.tile_type.WALL && E.type != AntHillGenerator.tile_type.NONE:
			adjacent_rooms[dir.E] = E

	if current_room.x - 1 >= 0: # West/Left
		var W = world_grid.get_cell(current_room.x - 1, current_room.y)
		if W.type != AntHillGenerator.tile_type.WALL && W.type != AntHillGenerator.tile_type.NONE:
			adjacent_rooms[dir.W] = W


func print_adjacent_rooms():
	print(adjacent_rooms[dir.N].scene, " at: ", adjacent_rooms[dir.N].x, ", ", adjacent_rooms[dir.N].y)
	print(adjacent_rooms[dir.S].scene, " at: ", adjacent_rooms[dir.S].x, ", ", adjacent_rooms[dir.S].y)
	print(adjacent_rooms[dir.E].scene, " at: ", adjacent_rooms[dir.E].x, ", ", adjacent_rooms[dir.E].y)
	print(adjacent_rooms[dir.W].scene, " at: ", adjacent_rooms[dir.W].x, ", ", adjacent_rooms[dir.W].y)


func load_room(direction: String):
	#we load here to always get the right room
	find_adjacent_rooms()
	#print_adjacent_rooms()
	var next_room
	
	match direction:
		"N":	
			next_room = adjacent_rooms[dir.N]
			came_from = "S"
		"S":
			next_room = adjacent_rooms[dir.S]
			came_from = "N"
		"E":
			next_room = adjacent_rooms[dir.E]
			came_from = "W"
		"W":	
			next_room = adjacent_rooms[dir.W]
			came_from = "E"
	if(next_room != null) :
		TransitionScene.change_scene(next_room.scene)
		current_room = next_room
		#here somehow get access to the current player and set its position to where we came from
		print("current room at: ", current_room.x, ", ", current_room.y)
	else:
		print("next room is null!")
	GameState.update_item_display()

func assign_rooms():
	for x in range(AntHillGenerator.size_x):
		for y in range(AntHillGenerator.size_y):
			current_room = world_grid.get_cell(x, y)
			find_adjacent_rooms()
			match current_room.type:
				AntHillGenerator.tile_type.WALL:		current_room.scene = null
				AntHillGenerator.tile_type.ROOM:
					match AntHillGenerator.get_room_neighbor_amount(current_room):
						1: choose_one_door_rooms("tunnel")
						2: choose_two_door_rooms()
						3: choose_three_door_rooms("tunnel")
						4: current_room.scene = four_door_tunnels.pick_random() # only one that does not need to change for the right door
				AntHillGenerator.tile_type.START:
					match AntHillGenerator.get_room_neighbor_amount(current_room):
						#1: choose_one_door_rooms("tunnel")
						#2: choose_two_door_rooms()
						3: choose_three_door_rooms("start")
						4: current_room.scene = starts[4]
				AntHillGenerator.tile_type.QUEEN:		choose_one_door_rooms("queen")
				AntHillGenerator.tile_type.NURSERY:		choose_one_door_rooms("nursery")
				AntHillGenerator.tile_type.CARPENTER:	choose_one_door_rooms("carpenter")
				AntHillGenerator.tile_type.WATER:		choose_one_door_rooms("water")
				AntHillGenerator.tile_type.FOOD:		choose_one_door_rooms("food")
				AntHillGenerator.tile_type.COIN:		choose_one_door_rooms("coin")
				_:										current_room.scene = null
	current_room = start_room #set it to start room so we can start in the right room... maybe we should use something else but whatever

func choose_one_door_rooms(kind: String):
	var room_array
	match kind:
		"tunnel": 		room_array = one_door_tunnels
		"nursery":		room_array = nurseries
		"food":			room_array = foods
		"carpenter":	room_array = carpenters
		"queen":		room_array = queens
		"water":		room_array = waters
		"coin":			room_array = coins
	if adjacent_rooms[dir.N] != null:
		current_room.scene = room_array[0]
	if adjacent_rooms[dir.E] != null:
		current_room.scene = room_array[1]
	if adjacent_rooms[dir.S] != null:
		current_room.scene = room_array[2]
	if adjacent_rooms[dir.W] != null:
		current_room.scene = room_array[3]

func choose_two_door_rooms():
	if adjacent_rooms[dir.N] != null:
		if adjacent_rooms[dir.E] != null:
			current_room.scene = two_door_tunnels[0]
		if adjacent_rooms[dir.S] != null:
			current_room.scene = two_door_tunnels[1]
		if adjacent_rooms[dir.W] != null:
			current_room.scene = two_door_tunnels[2]
	
	if adjacent_rooms[dir.S] != null:
		if adjacent_rooms[dir.E] != null:
			current_room.scene = two_door_tunnels[3]
		if adjacent_rooms[dir.W] != null:
			current_room.scene = two_door_tunnels[4]
	
	if adjacent_rooms[dir.E] != null && adjacent_rooms[dir.W] != null:
		current_room.scene = two_door_tunnels[5]

func choose_three_door_rooms(kind: String):
	var room_array
	match kind:
		"tunnel": 		room_array = three_door_tunnels
		"start":		room_array = starts
	if adjacent_rooms[dir.N] == null:
		current_room.scene = room_array[0]
	if adjacent_rooms[dir.E] == null:
		current_room.scene = room_array[1]
	if adjacent_rooms[dir.S] == null:
		current_room.scene = room_array[2]
	if adjacent_rooms[dir.W] == null:
		current_room.scene = room_array[3]

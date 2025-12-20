extends Node2D



var world_grid
var nurseries = []
var foods = []
var carpenters = []
var queens = []
var waters = []
var one_door_tunnels = []
var two_door_tunnels  = []# maybe another way to store them or note the order
var three_door_tunnels = []
var four_door_tunnels = []
var start_room

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
	print("world grid 00 type: ",world_grid.get_cell(0,0).type)
	fill_room_arrays()
	
	#assign_rooms()
	
	current_room = start_room
	
	find_adjacent_rooms()
	
	TransitionScene.change_scene(start_room.scene)

func fill_room_arrays():
	four_door_tunnels.append("res://Scenes/level_example.tscn")
	nurseries.append("res://Scenes/level_example.tscn")
	foods.append("res://Scenes/level_example.tscn")
	carpenters.append("res://Scenes/level_example.tscn")
	queens.append("res://Scenes/level_example.tscn")
	waters.append("res://Scenes/level_example.tscn")
	one_door_tunnels.append("res://Scenes/level_example.tscn")
	two_door_tunnels.append("res://Scenes/level_example.tscn")
	three_door_tunnels.append("res://Scenes/level_example.tscn")
	four_door_tunnels.append("res://Scenes/level_example.tscn")
	start_room.scene = "res://Scenes/level_example.tscn"

func find_adjacent_rooms():
	#check if we can index there and then add the room as adjacent
	if current_room.x - 1 >= 0: # up
		var N = world_grid.get_cell(current_room.x -1, current_room.y)
		adjacent_rooms[dir.N] = N

	if current_room.x + 1 < world_grid.x: # down
		var S = world_grid.get_cell(current_room.x +1, current_room.y)
		adjacent_rooms[dir.S] = S

	if current_room.y + 1 >= 0: # right
		var E = world_grid.get_cell(current_room.x, current_room.y +1)
		adjacent_rooms[dir.E] = E

	if current_room.y - 1 < world_grid.y: #left
		var W = world_grid.get_cell(current_room.x, current_room.y -1)
		adjacent_rooms[dir.W] = W


func load_room(direction: String):
	#we load here to always get the right room
	match direction:
		"N":	TransitionScene.change_scene(adjacent_rooms[dir.N].scene)
		"S":	TransitionScene.change_scene(adjacent_rooms[dir.S].scene)
		"E":	TransitionScene.change_scene(adjacent_rooms[dir.E].scene)
		"W":	TransitionScene.change_scene(adjacent_rooms[dir.W].scene)


func assign_rooms():
	for x in range(AntHillGenerator.size_x):
		for y in range(AntHillGenerator.size_y):
			match world_grid.get_cell(x, y).type:
				AntHillGenerator.tile_type.WALL:		world_grid.get_cell(x, y).scene = null
				AntHillGenerator.tile_type.ROOM:
					match AntHillGenerator.get_room_neighbor_amount(world_grid.get_cell(x, y)):
						1: world_grid.get_cell(x, y).scene = one_door_tunnels.pick_random() # change this for the right door
						2: world_grid.get_cell(x, y).scene = two_door_tunnels.pick_random() # change this to check for the right doors
						3: world_grid.get_cell(x, y).scene = three_door_tunnels.pick_random() # change this for the right doors
						4: world_grid.get_cell(x, y).scene = four_door_tunnels.pick_random() # only one that does not need to change for the right door
				AntHillGenerator.tile_type.START:		world_grid.get_cell(x, y).scene = start_room
				AntHillGenerator.tile_type.QUEEN:		world_grid.get_cell(x, y).scene = queens[0]
				AntHillGenerator.tile_type.NURSERY:		world_grid.get_cell(x, y).scene = nurseries[0]
				AntHillGenerator.tile_type.CARPENTER:	world_grid.get_cell(x, y).scene = carpenters[0]
				AntHillGenerator.tile_type.WATER:		world_grid.get_cell(x, y).scene = waters[0]
				AntHillGenerator.tile_type.FOOD:		world_grid.get_cell(x, y).scene = foods[0]
				_:										world_grid.get_cell(x, y).scene = null


func _process(delta: float) -> void:
	pass

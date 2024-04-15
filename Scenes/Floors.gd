extends Node2D

signal change_floors(to: int)

@export var floor_spread: float = 10000
@export_enum("Executive Offices", "Cube Farm", "Lobby", "Basement") var active_floor: int = 0
var floors: Array[Node2D] = []
var active_locations: Array[Vector2] = []
var banishment_locations: Array[Vector2] = []

func initialize_floors():
	## Move all the floors off to their own unique off-screen location
	var idx = 0;
	for floor_node in self.get_children():
		# Save the floor to the local list so we can recall it later
		floors.push_back(floor_node)
		# Banish each floor to its corner
		var banishment_location = Vector2(-floor_spread, idx * -floor_spread)
		banishment_locations.push_back(banishment_location)
		active_locations.push_back(floor_node.position)
		floor_node.position = banishment_location
		# increment the y-banishment offset
		idx += 1

func change_floor_to(to: int):
	# Put away the currently active floor
	floors[active_floor].position = banishment_locations[active_floor]
	# Swap in the new one
	active_floor = to
	floors[to].position = active_locations[to]
	change_floors.emit(active_floor)

# Called when the node enters the scene tree for the first time.
func _ready():
	initialize_floors()
	change_floor_to(active_floor)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

extends Node2D

signal change_floors(to: int)

@export var active_floor: int = 3
var floors: Array[Node2D] = []

func initialize_floors():
	for node in self.get_children():
		floors.push_back(node)
		self.remove_child(node)

func change_floor_to(to: int):
	# Put the current floor on the shelf
	var children = self.get_children()
	match children.size():
		0:
			pass
		1:
			var floor_to_reinsert = children.pop_front()
			self.remove_child(floor_to_reinsert)
			floors.insert(active_floor, floor_to_reinsert)
		var N:
			printerr("got too many floor children: ", N)
		
	# Take out the new floor and put it in the scene
	active_floor = to
	self.add_child(floors.pop_at(active_floor))
	change_floors.emit(active_floor)

# Called when the node enters the scene tree for the first time.
func _ready():
	initialize_floors()
	change_floor_to(active_floor)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

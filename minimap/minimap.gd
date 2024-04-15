extends Node2D

@export var floor_controller: Node2D

@onready var sprite = $ViewportSprite
@onready var stack = $"Viewport/Floor Stack"
@onready var viewport = $Viewport

var active_floor: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# Fish out the list of floors and pass them on to the floor stack renderer
	if floor_controller:
		var floors: Array[Node] = floor_controller.get_children()
		stack.floors = floors
	
	# Wire up the output render for the minimap viewport
	sprite.texture = viewport.get_texture()
	stack.instantiate_floors()
	self.change_floor_to(active_floor)

func change_floor_to(to: int):
	active_floor = to
	stack.change_floor_to(to)

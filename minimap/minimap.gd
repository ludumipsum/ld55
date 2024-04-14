extends Node2D

@export var floor_controller: Node2D

@onready var sprite = $ViewportSprite
@onready var stack = $"Viewport/Floor Stack"
@onready var viewport = $Viewport

var active_floor: int

# Called when the node enters the scene tree for the first time.
func _ready():
	var floors: Array[Node] = floor_controller.get_children()
	active_floor = floors.size() - 1
	sprite.texture = viewport.get_texture()
	stack.floors = floors
	stack.instantiate_floors()
	self.change_floor_to(active_floor)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func change_floor_to(to: int):
	active_floor = to
	stack.change_floor_to(to)

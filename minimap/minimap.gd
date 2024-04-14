extends Node2D

@export var floors: Array[Node2D]

@onready var sprite = $ViewportSprite
@onready var stack = $"Viewport/Floor Stack"
@onready var viewport = $Viewport

var active_floor: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.texture = viewport.get_texture()
	stack.floors = floors
	stack.instantiate_floors()
	self.change_floor_to(1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_floor_hiddens():
	var idx = 0
	for f in floors:
		f.visible = true if active_floor == idx else false
		idx += 1

func change_floor_to(to: int):
	active_floor = to
	stack.change_floor_to(to)

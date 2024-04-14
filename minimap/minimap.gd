extends Node2D

@export var floors: Array[Node2D]

@onready var sprite = $ViewportSprite
@onready var stack = $"Viewport/Floor Stack"
@onready var viewport = $Viewport

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.texture = viewport.get_texture()
	stack.floors = floors
	stack.instantiate_floors()
	self.change_floor_to(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func change_floor_to(to: int):
	stack.change_floor_to(to)

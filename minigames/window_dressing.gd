extends Node2D

var rect
@export var width = 320
@export var height = 160
@export var stroke_width = 2.0

# Called when the node enters the scene tree for the first time.
func _ready():
	rect = Rect2(0, 0, width, height)

func _draw():
	draw_rect(rect, Color.ANTIQUE_WHITE, false, stroke_width)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

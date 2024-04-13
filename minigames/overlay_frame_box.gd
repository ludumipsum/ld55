extends Node2D

var rect
@export var width = 324
@export var height = 164
@export var stroke_width = 2.0

@export var background_color = Color.SLATE_GRAY
@export var border_color = Color.ANTIQUE_WHITE

# Called when the node enters the scene tree for the first time.
func _ready():
	rect = Rect2(-width/2.0, -height/2.0, width, height)

func _draw():
	draw_rect(rect, background_color, true)
	draw_rect(rect, border_color, false, stroke_width)

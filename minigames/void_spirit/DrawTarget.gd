extends Node2D

var max_size : float = 0.0
var min_size : float = 0.0
var fill : float = 0.0

func _draw():
	var max_variable = max_size - min_size
	var variable = max_variable * fill
	var size = variable + min_size
	var color = Color.MIDNIGHT_BLUE
	
	draw_circle(Vector2.ZERO, size, color)

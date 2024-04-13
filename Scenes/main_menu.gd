extends Node2D
@onready var indicators = $Menu_Indicators
@onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# flashes menu indicators
func _on_timer_timeout():
	if indicators.visible == true:
		indicators.hide()
	else :
		indicators.show()

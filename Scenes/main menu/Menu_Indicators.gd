extends Control
@onready var indicators = $Menu_Indicators


# Called when the node enters the scene tree for the first time.
func _ready():
	flash_indicators()

func flash_indicators():
	indicators.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

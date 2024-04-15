extends CanvasLayer

var seen = false
var yes

@onready var textbox = self
@onready var text = $textbox_container/MarginContainer/HBoxContainer/text
@onready var select = $select

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func hide_textbox():
	text.text = ""
	textbox.hide()
	seen = false

func show_textbox():
	textbox.show()
	seen = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
		pass

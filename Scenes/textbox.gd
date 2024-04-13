extends CanvasLayer


@onready var textbox = $textbox_container
@onready var text = $textbox_container/MarginContainer/HBoxContainer/text

# Called when the node enters the scene tree for the first time.
func _ready():
	hide_textbox()

func hide_textbox():
	text.text = ""
	textbox.hide()

func show_textbox():
	textbox.show()

func add_text(next_text):
	text.text = next_text
	show_textbox()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_trigger_playgame_body_entered(body):
	add_text("start game?")

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
	textbox.hide()
	seen = false

func show_textbox():
	textbox.show()
	up_select()
	seen = true


func up_select():
	text.text ="it's your job to keep the spirits of the office where they need to be to keep things running smoothly.

use the elevator to check each floor for missing spirits.

If a spirit is missing, your compass will point you to where you need to perform the summoning ritual.

you can use the book in here to practice the rituals.

are you ready to get to work?
	yes? <
	no?"
	yes = true


func down_select():
	text.text ="it's your job to keep the spirits of the office where they need to be to keep things running smoothly.

use the elevator to check each floor for missing spirits.

If a spirit is missing, your compass will point you to where you need to perform the summoning ritual.

you can use the book in here to practice the rituals.

are you ready to get to work?
	yes?
	no? <"
	yes = false


func action():
	if yes == true:
		get_tree().change_scene_to_file("res://Scenes/the_office.tscn")
	else:
		hide_textbox()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if seen == true:
		if Input.is_action_just_pressed("move_up") == true:
			select.play()
			up_select()
		if Input.is_action_just_pressed("move_down") ==true:
			select.play()
			down_select()
		if Input.is_action_just_pressed("action") == true:
			select.play()
			action()
		
		
	else:
		pass


func _on_trigger_playgame_body_entered(_body):
	show_textbox()

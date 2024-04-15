extends CanvasLayer

signal change_floor_to(floor)

var carats: Array
var seen = false
var option = 0
var textbox = self
@onready var select = $select

# Called when the node enters the scene tree for the first time.
func _ready():
	var options = $textbox_container/MarginContainer/HBoxContainer/OptionList.get_children()
	for option in options:
		carats.push_back(option.get_node("active_marker"))
	pass

func hide_textbox():
	textbox.hide()
	seen = false

func show_textbox():
	textbox.show()
	seen = true

func show_carat_for(option: int):
	for carat in carats:
		carat.text = "  "
	carats[option].text = ">"

func up_select():
	if option <= 0:
		option = 0
	else:
		option -= 1
		show_carat_for(option)

func down_select():
	if option == carats.size() - 1:
		option = carats.size() - 1
	else:
		option += 1
		show_carat_for(option)

func action():
	hide_textbox()
	change_floor_to.emit(option)

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


func _on_trigger_options_body_entered(_body):
	show_textbox()

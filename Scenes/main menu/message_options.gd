extends CanvasLayer

@onready var label1 = $textbox_container/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/Label1
@onready var label2 = $textbox_container/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer5/Label2
@onready var label3 = $textbox_container/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer4/Label3

var seen = false
var option = 1
var textbox = self

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func hide_textbox():
	textbox.hide()
	seen = false


func show_textbox():
	textbox.show()
	seen = true


func up_select():
	if option == 1:
		pass
	else:
		option -= 1
		match option:
			1:
				label1.show()
				label2.hide()
				label3.hide()
			2:
				label1.hide()
				label2.show()
				label3.hide()
			3:
				label1.hide()
				label2.hide()
				label3.show()


func down_select():
	if option == 3:
		pass
	else:
		option += 1
		match option:
			1:
				label1.show()
				label2.hide()
				label3.hide()
			2:
				label1.hide()
				label2.show()
				label3.hide()
			3:
				label1.hide()
				label2.hide()
				label3.show()


func action():
		if option == 1:
			opt1()
		if option == 2:
			opt2()
		if option == 3:
			opt3()


func opt1():
	hide_textbox()


func opt2():
	hide_textbox()


func opt3():
	hide_textbox()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if seen == true:
		if Input.is_action_just_pressed("move_up") == true:
			up_select()
		if Input.is_action_just_pressed("move_down") ==true:
			down_select()
		if Input.is_action_just_pressed("action") == true:
			action()
		
		
	else:
		pass


func _on_trigger_options_body_entered(_body):
	show_textbox()

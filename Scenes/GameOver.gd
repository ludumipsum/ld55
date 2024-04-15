extends CanvasLayer

@onready var overlay = $Control
@onready var nr_summon_label = $Control/VBoxContainer/HBoxContainer/NrSummoned
@onready var nr_total_label = $Control/VBoxContainer/HBoxContainer/NrTotal

var showing: bool = false

func _on_game_over(summoned: int, total: int):
	nr_summon_label.text = "%d" % summoned
	nr_total_label.text = "%d" % total
	overlay.show()
	showing = true

func _physics_process(delta):
	if showing && Input.is_action_just_pressed("action"):
		get_tree().change_scene_to_file("res://Scenes/main menu/main_menu.tscn")

extends Control

var is_paused = false

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		is_paused = !is_paused
		get_tree().paused = is_paused
		visible = is_paused


func _on_play_pressed():
	is_paused = false
	get_tree().paused = is_paused
	visible = is_paused

func _on_quit_pressed():
	get_tree().quit()


func _on_main_menu_pressed():
	is_paused = false
	get_tree().paused = is_paused
	visible = is_paused
	get_tree().change_scene_to_file("res://Scenes/main menu/main_menu.tscn")

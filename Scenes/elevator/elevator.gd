extends Node2D

signal change_floor_to(floor)
signal dialog_opened_closed

@onready var ding = $elevator

func _on_change_floor_to(floor):
	change_floor_to.emit(floor)
	ding.play()

func _on_message_options_visibility_changed():
	dialog_opened_closed.emit()

extends Node2D

signal change_floor_to(floor)
signal dialog_opened_closed

func _on_change_floor_to(floor):
	change_floor_to.emit(floor)

func _on_message_options_visibility_changed():
	dialog_opened_closed.emit()

extends Control

func show_info(info: String):
	$Label.text = info
	$AnimationPlayer.play("info")

extends Node2D

@export var animation: AnimationPlayer

func play():
	animation.play("blow")

func _on_blow_animation_finished(_anim_name):
	self.queue_free()

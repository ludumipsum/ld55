extends Node2D
class_name Spirit

signal animation_finished

enum Element {Grass, Light, Fire, Water, Earth, Air, Writing, Void}

@export var element: Element
@onready var player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	match element:
		Element.Grass:
			modulate = Color.GREEN_YELLOW
		Element.Light:
			modulate = Color.YELLOW
		Element.Fire:
			modulate = Color.ORANGE_RED
		Element.Water:
			modulate = Color.BLUE
		Element.Earth:
			modulate = Color.BURLYWOOD
		Element.Air:
			modulate = Color.SKY_BLUE
		Element.Writing:
			modulate = Color.GRAY
		Element.Void:
			modulate = Color.REBECCA_PURPLE
	player.queue("summon")
	player.queue("idle")
	player.queue("idle")
	player.queue("RESET")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "RESET":
		animation_finished.emit()

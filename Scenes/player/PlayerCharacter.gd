extends CharacterBody2D
class_name PlayerCharacter

@export var speed = 100.0

@onready var animation_tree = $AnimationTree

var isfrozen = false
var player = self

func get_new_velocity():
	var input_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	return input_vector * speed


func _physics_process(_delta):
	velocity = get_new_velocity()
	update_animation_state()
	move_and_slide()

func update_animation_state():
	if velocity == Vector2.ZERO:
		animation_tree["parameters/conditions/is_idle"] = true
		animation_tree["parameters/conditions/is_moving"] = false
	if velocity != Vector2.ZERO:
		animation_tree["parameters/conditions/is_idle"] = false
		animation_tree["parameters/conditions/is_moving"] = true
		animation_tree["parameters/idle/blend_position"] = velocity
		animation_tree["parameters/walk/blend_position"] = velocity

func freeze():
	if isfrozen == true:
		player.set_physics_process(true)
		player.set_process_input(true)
		isfrozen = false
	else:
		player.set_physics_process(false)
		player.set_process_input(false)
		isfrozen = true
		animation_tree["parameters/conditions/is_idle"] = true
		animation_tree["parameters/conditions/is_moving"] = false
#

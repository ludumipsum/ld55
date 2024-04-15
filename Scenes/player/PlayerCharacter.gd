extends CharacterBody2D
class_name PlayerCharacter

@export var speed = 100.0

@onready var animation_tree = $AnimationTree
@onready var compass = $Compass
var compass_target = null

var isfrozen = false
var player = self

func get_new_velocity():
	var input_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	return input_vector * speed

func _process(delta):
	if compass_target && compass.visible:
		update_compass()

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

func update_compass():
	## Point the player's compass to the given node
	var ppos = self.global_position
	var tpos = compass_target.global_position
	var look = (tpos - ppos).normalized()
	var angle = look.angle() - (PI/2)
	compass.rotation = angle

func show_compass(to: Node2D):
	## Enable the player's compass and point it to this node
	compass_target = to
	compass.show()

func hide_compass():
	## Disable the player's compass
	compass_target = null
	compass.hide()

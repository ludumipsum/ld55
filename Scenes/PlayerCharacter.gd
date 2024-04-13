extends CharacterBody2D

var isfrozen = false
var player = self
@export var speed = 100.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func get_input():
	var input_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	return input_vector


func _physics_process(_delta):
	var input = get_input()
	
	set_velocity(input * speed)
	move_and_slide()


func freeze():
	if isfrozen == true:
		player.set_physics_process(true)
		player.set_process_input(true)
		isfrozen = false
	else:
		player.set_physics_process(false)
		player.set_process_input(false)
		isfrozen = true
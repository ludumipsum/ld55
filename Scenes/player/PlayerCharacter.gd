extends CharacterBody2D
class_name PlayerCharacter

@export var speed = 100.0

var isfrozen = false
var player = self


@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
var facing : Direction = Direction.UP
var is_walking : bool = false

enum Direction {RIGHT, DOWN, LEFT, UP}

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func get_input():
	var input_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	return input_vector


func _physics_process(_delta):
	var input_vector = get_input()

	var facing = get_facing(input_vector)
	var is_walking = true if input_vector.length() > 0.1 else false
	
	if player.facing != facing || player.is_walking != is_walking:
		player.facing = facing
		player.is_walking = is_walking
		update_animation()

	player.velocity = input_vector * speed
	move_and_slide()



func freeze():
	if isfrozen == true:
		player.set_physics_process(true)
		player.set_process_input(true)
		player.animated_sprite.play()
		isfrozen = false
	else:
		player.set_physics_process(false)
		player.set_process_input(false)
		player.animated_sprite.pause()
		isfrozen = true



func get_facing(input_vector: Vector2) -> float:
	if input_vector.length() < 0.1:
		return player.facing

	var a = input_vector.angle()
	if a >= -(3.0/4.0)*PI && a <= -(1.0/4.0)*PI:
		return Direction.UP
	elif a > -(1.0/4.0)*PI && a < (1.0/4.0)*PI:
		return Direction.RIGHT
	elif a >= (1.0/4.0)*PI && a <= (3.0/4.0)*PI:
		return Direction.DOWN
	# spans [(3/4)PI..PI] and then [-PI..-(3/4)PI].
	return Direction.LEFT

func update_animation():
	match [player.facing, player.is_walking]:
		[Direction.LEFT, true]:
			animated_sprite.play("walk_left")
		[Direction.RIGHT, true]:
			animated_sprite.play("walk_right")
		[Direction.UP, true]:
			animated_sprite.play("walk_up")
		[Direction.DOWN, true]:
			animated_sprite.play("walk_down")
		[Direction.LEFT, false]:
			animated_sprite.play("idle_left")
		[Direction.RIGHT, false]:
			animated_sprite.play("idle_right")
		[Direction.UP, false]:
			animated_sprite.play("idle_up")
		[Direction.DOWN, false]:
			animated_sprite.play("idle_down")

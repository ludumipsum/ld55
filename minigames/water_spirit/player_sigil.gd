extends CharacterBody2D

@export var speed : float = 250.0

func get_new_velocity():
	var input_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	return input_vector * speed

func _draw():
	self.draw_circle(Vector2.ZERO, 10.0, Color.DARK_MAGENTA)

func _physics_process(_delta):
	velocity = get_new_velocity()
	move_and_slide()

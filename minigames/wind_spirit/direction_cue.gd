extends Node2D

signal puzzle_finished

const UP = "move_up"
const DOWN = "move_down"
const LEFT = "move_left"
const RIGHT = "move_right"
const ACT = "action"

@export var sequence = [UP, UP, DOWN, DOWN, LEFT, RIGHT, LEFT, RIGHT, ACT]
@export var blow_anim_scene = load("res://minigames/wind_spirit/wind_effect.tscn")
@export var cooldown: float = 0.5

@export var neutral_color: Color = Color.TEAL
@export var miss_color: Color = Color.RED
@export var hit_color: Color = Color.GREEN


var remaining = []
var blower
var input_needed
var current_cooldown = 0.0

func _ready():
	reset()

func reset():
	if blower:
		blower.queue_free()
		blower = null
	remaining = sequence.duplicate()
	spawn_next()

func spawn_next():
	if remaining.is_empty():
		puzzle_finished.emit()
		return
	
	# Configure the state for the next input needed
	input_needed = remaining.pop_front()
	blower = blow_anim_scene.instantiate()
	
	add_child(blower)
	
	# Rotate the indicator based on the next input
	var indicator_rotation
	match input_needed:
		UP:
			indicator_rotation = 0
		RIGHT:
			indicator_rotation = 90
		DOWN:
			indicator_rotation = 180
		LEFT:
			indicator_rotation = -90
		ACT:
			indicator_rotation = 45
	blower.rotate(deg_to_rad(indicator_rotation))

func check_wrong_input():
	var wrong_actions = [
		UP, RIGHT, DOWN, LEFT, ACT
	].filter(func(i): return i != input_needed)
	for wrong_action in wrong_actions:
		if Input.is_action_just_pressed(wrong_action):
			current_cooldown = cooldown

func _process(delta):
	if current_cooldown > 0:
		current_cooldown -= delta
		if current_cooldown <= 0:
			reset()
		else:
			return
	
	check_wrong_input()
	if Input.is_action_just_pressed(input_needed):
		blower.play()
		spawn_next()
	

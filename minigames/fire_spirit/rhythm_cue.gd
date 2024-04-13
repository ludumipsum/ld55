extends Node2D

signal puzzle_finished

@export var width: float = 16 * 4
@export var height: float = 16 * 2
@export var stroke_width: float = 3.0
@export var bpm: float = 90.0
@export var fudge_factor: float = 0.05

@export var successes_required: int = 5

@export var neutral_color: Color = Color.TEAL
@export var miss_color: Color = Color.RED
@export var hit_color: Color = Color.GREEN

var time: float = 0
var coyote_bit = false
var missed_beat: bool = false
var hit_beat: bool = false
var target_area_ratio: float
var successes = 0
var alpha: float = 0.0

func _ready():
	pass

func reset_beat():
	if hit_beat:
		successes += 1
	missed_beat = false
	hit_beat = false
	while time > 1.0:
		time -= 1.0

func _process(delta):
	# Handle completion if the previous frame had the last beat hit
	if successes >= successes_required:
		puzzle_finished.emit()
	
	# Step the timer forward to scale the beat pulser
	var time_dilation_factor = bpm / 60.0
	time += (delta * time_dilation_factor)
	if time > 1.0:
		reset_beat()
	queue_redraw()
	
	# Alpha for drawing and detecting completion
	alpha = smoothstep(0.0, 1.0, time)
	var target_area_ratio = stroke_width * (1.0 + fudge_factor) / height
	
	# Handle inputs
	var act = Input.is_action_just_pressed("minigame_action")
	var in_coyote_time = time < fudge_factor				# little extra into the next frame
	var in_target_time = alpha > (1.0 - target_area_ratio)	# on-the-beat hit
	if act && missed_beat == false && hit_beat == false:
		if in_target_time:
			hit_beat = true		# record the hit
			coyote_bit = true	# mark that this was in regular time, so coyote time isn't allowed
								# at the top of the next cycle
			return
		if in_coyote_time && !coyote_bit:
			hit_beat = true
			return
		missed_beat = true
	if !in_target_time && !in_coyote_time && coyote_bit:
		coyote_bit = false

func _draw():
	draw_pulse_box()
	#draw_target_area()

func draw_target_area():
	var draw_width = width * target_area_ratio
	var draw_height = height * target_area_ratio
	var x = -(draw_width / 2)
	var y = -(draw_height / 2)
	var rect = Rect2(x, y, draw_width, draw_height)
	draw_rect(rect, Color.GREEN, true)

func draw_pulse_box():
	var draw_width = width * (1.0 - alpha)
	var draw_height = height * (1.0 - alpha)
	var x = -(draw_width / 2)
	var y = (-draw_height / 2)
	var rect = Rect2(x, y, draw_width, draw_height)
	
	var color = neutral_color
	if missed_beat:
		color = miss_color
	if hit_beat:
		color = hit_color
	
	draw_rect(rect, color, false, stroke_width)

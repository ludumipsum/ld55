extends SummoningMinigame
class_name SummonVoidSpirit

@export var target_points  : int = 100
@export var points_per_hit : int = 20
@export var decay_per_second : int = 40

@export var circle_max_size : int = 120
@export var circle_min_size : int = 10

@export var draw_target : Node2D

var points : float = 0

func _ready():
	draw_target.min_size = circle_min_size
	draw_target.max_size = circle_max_size
 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("action"):
		points += points_per_hit
	if points >= target_points:
		puzzle_finished.emit()
		self.queue_free()
	
	points -= decay_per_second * delta
	points = clamp(points, 0, target_points)

	draw_target.fill = points/target_points
	draw_target.queue_redraw()

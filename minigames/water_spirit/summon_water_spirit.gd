extends SummoningMinigame
class_name SummonWaterSpirit

const DROPLET : Resource = preload("res://minigames/water_spirit/droplet.tscn")
const SPAWN_DISTANCE : float = 120

@export var timeout : float = 3.0
@export var droplet_count : int = 5
@export var droplet_min_wait_secs : float = 0.1
@export var droplet_max_wait_secs : float = 0.3

@export var player : CharacterBody2D

@onready var frame = $"Minigame Frame"

var finished : bool = false
var droplets_spawned : int = 0

var droplet_timer : Timer = Timer.new()
var timeout_timer : Timer = Timer.new()

var droplets : Array[Droplet] = []

func _ready():
	self.add_child(timeout_timer)
	timeout_timer.timeout.connect(_on_timeout_timer_tick)
	timeout_timer.start(timeout)

	self.add_child(droplet_timer)
	droplet_timer.timeout.connect(_on_droplet_timer_tick)
	
	reset()

func reset():
	for droplet in droplets:
		if droplet != null:
			droplet.queue_free()
		
	droplets.clear()

	timeout_timer.stop()
	timeout_timer.start(timeout)

	droplet_timer.stop()
	droplets_spawned = 0

	_on_droplet_timer_tick()

func _process(_delta):
	if finished:
		puzzle_finished.emit()
		queue_free()

func spawn_droplet() -> Droplet:
	var spawn_angle = randf_range(0, 2*PI)
	var spawn_position = Vector2(SPAWN_DISTANCE, 0).rotated(spawn_angle)
	
	var droplet = DROPLET.instantiate()
	droplet.position = spawn_position
	droplet.rotation = spawn_angle - (3.0/2.0)*PI
	droplet.travel_limit = SPAWN_DISTANCE * 2
	droplet.target = player
	droplet.target_hit.connect(_on_droplet_target_hit)
	
	droplets.push_back(droplet)
	return droplet
	
func _on_droplet_timer_tick():
	frame.add_child(spawn_droplet())
	droplets_spawned += 1
	if droplets_spawned < droplet_count:
		droplet_timer.start(randf_range(droplet_min_wait_secs, droplet_max_wait_secs))
	else:
		droplet_timer.stop()

func _on_droplet_target_hit():
	reset()

func _on_timeout_timer_tick():
	finished = true

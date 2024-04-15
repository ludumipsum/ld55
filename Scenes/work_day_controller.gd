extends Node
class_name WorkDayController

signal new_work_order(text)
signal day_over(summoned, total)

## The root of the game's playable area, the floors list
@export var floors_list_root: FloorsList
@export var player: PlayerCharacter
@export var clock_label: Label
@export var summoned_spirits_counter: Label
@export var total_spirits_counter: Label
@export var active_spirits_counter: Label

## How long we wait in between each summoning point activation
@export_group("Work Day Parameters")
@export var activation_period: float = 10.0
@export var day_progress: float = 0.0

## The set of all summoning points in all floors in the game
@onready var summoning_points: Array[SummoningPoint] = scan_summoning_points(floors_list_root)
@onready var summoning_points_by_floor: Array = scan_summoning_points_by_floor(floors_list_root)
@onready var activation_timer = $ActivationTimer

var nr_total = 0
var nr_summoned = 0
var nr_active = 0

func scan_summoning_points(root: Node):
	## Find all summoning points in the scene graph below this node
	var points: Array[SummoningPoint] = []
	if root is SummoningPoint:
		points.push_back(root)
	for child in root.get_children():
		for point in scan_summoning_points(child):
			points.push_back(point)
	return points
	
func scan_summoning_points_by_floor(root: Node):
	## Find all summoning points in the scene graph below this node
	var points_by_floor = []
	for child_floor in root.get_children():
		var points = scan_summoning_points(child_floor)
		points_by_floor.push_back(points)
	return points_by_floor

func update_player_compass():
	var active_floor = floors_list_root.get_active_floor()
	var summons_on_floor = summoning_points_by_floor[active_floor].duplicate()
	var actives_on_floor = summons_on_floor.filter(func(a: SummoningPoint): return a.is_active())
	if actives_on_floor.is_empty():
		player.hide_compass()
		return
	var nearest_active = actives_on_floor[0]
	var nearest_distance = 9999999999.0
	for point in actives_on_floor:
		var dist = (player.position - point.position).length()
		if dist < nearest_distance:
			nearest_active = point
			nearest_distance = dist
	player.show_compass(nearest_active)
	
func _physics_process(_delta):
	update_player_compass()
	update_labels()

func _ready():
	randomize()
	link_common_signals()

func link_common_signals():
	## Scan all summoning points and link up their output signals
	for point in summoning_points:
		point.toggle_inputs.connect(self.toggle_interact_for_all)
		#point.toggle_inputs.connect(player.freeze)
		point.all_spirits_summoned.connect(self._on_summon_complete)
		point.timeout.connect(self._on_summon_failed)

func activate_random():
	nr_active += 1
	nr_total += 1
	var inactive_points = []
	for point in summoning_points:
		if not point.is_active():
			inactive_points.push_back(point)
	var next = randi() % inactive_points.size()
	inactive_points[next].activate()
	new_work_order.emit("A new work order came in!")
	print("chose %s" % inactive_points[next])

func update_labels():
	summoned_spirits_counter.text = "%d" % nr_summoned
	total_spirits_counter.text = "%d" % nr_total
	active_spirits_counter.text = "%d" % nr_active
	# clock labels
	var hours = floor(8.0 * (1.0 - day_progress))
	var minutes = 8.0 * (1.0 - day_progress)
	while minutes > 1.0:
		minutes -= 1.0
	minutes = floor(minutes * 60)
	clock_label.text = "%02d:%02d Left" % [hours, minutes]

# ##############################################################################
# Signal Handlers

func toggle_interact_for_all():
	player.freeze()
	for point in summoning_points:
		point.interact_disabled = !point.interact_disabled

func _on_difficulty_anim(anim_name):
	match anim_name:
		"work_day":
			self._on_work_day_end()
		_:
			printerr("difficulty/time curve anim end not configured")

func _on_work_day_end():
	## When the work day ends!
	## This is the end of the game, so we should play some sound or something,
	## and transition to whatever postgame summary and/or credits we want to do
	day_over.emit(nr_summoned, nr_total)

func _on_activation_timer_timeout():
	## When the activation timer indicates we need to activate another puzzle
	print("activating point (curve @ %f)" % self.activation_period)
	self.activate_random()
	activation_timer.start(self.activation_period)

func _on_summon_complete():
	## When the player finishes a summon in time
	nr_summoned += 1
	nr_active -= 1
	print("spirit summoned!")

func _on_summon_failed():
	## When the player fails to finish a summon in time
	nr_active -= 1

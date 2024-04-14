@icon("res://unsorted_assets/exclamation.png") 
class_name SummoningPoint
extends Node2D

## This summoning point became active (waiting for the player)
signal activated

## The player opened or closed a minigame associated with this summoning point
signal toggle_inputs

## This summoning point was not handled in time
signal timeout
## This summoning point was successfully handled!
signal all_spirits_summoned

enum SpiritType {FIRE, WIND}
@export var start_active: bool = false
@export var always_active: bool = false
@export_range(5, 300) var seconds_to_complete: float = 60
@export var spirits_required: Array[SpiritType]

## The spirits that still need to be summoned to complete this activation point
## (spirits_required, minus the ones the player already finished)
var remaining_spirits: Array[SpiritType] = []

@onready var fire_minigame = load("res://minigames/fire_spirit/summon_fire_spirit.tscn")
@onready var wind_minigame = load("res://minigames/wind_spirit/summon_wind_spirit.tscn")
@onready var lifespan: Timer = $LifespanTimer
@onready var viewport: SubViewport = $MinigameViewport
@onready var canvas: Sprite2D = $MinigameCanvas

func is_active():
	## Is this summoning point currently active?
	if !lifespan.is_stopped() && lifespan.time_left > 0.0:
		return true
	return false

func activate():
	## Activate this summoning point for the player to go fix
	remaining_spirits = spirits_required.duplicate()
	lifespan.start(seconds_to_complete)
	activated.emit()
	$ActionIndicator.visible = true

func reset():
	## Reset this summoning point to wait for its next activation
	lifespan.stop()
	canvas.hide()
	remaining_spirits = spirits_required.duplicate()
	$ActionIndicator.visible = false
	if always_active:
		self.activate()

# ##############################################################################
# Internal Logic

func _instantiate_summoning_minigame(spirit: SpiritType):
	## Create a summoning minigame by the requested type
	var instance: SummoningMinigame
	match spirit:
		SpiritType.FIRE:
			instance = fire_minigame.instantiate()
		SpiritType.WIND:
			instance = wind_minigame.instantiate()
		var otherwise:
			printerr("tried to instantiate unknown spirit summoning ritual: ", otherwise)
	return instance

func _spawn_next_summoning_minigame():
	## Spawn in the next summoning minigame the player needs to complete
	if remaining_spirits.is_empty():
		printerr("tried to spawn another summoning minigame when we're done with this")
		return
	var minigame: SummoningMinigame = self._instantiate_summoning_minigame(remaining_spirits[0])
	minigame.puzzle_finished.connect(self._on_puzzle_finished)
	minigame.puzzle_canceled.connect(self._on_puzzle_canceled)
	viewport.add_child(minigame)

# Called when the node enters the scene tree for the first time.
func _ready():
	if always_active:
		seconds_to_complete = 99999999999
	self.reset()
	if start_active:
		self.activate()

# ##############################################################################
# Signal Handlers

func _on_lifespan_timeout():
	## Signal handler: when this summoning point runs out of time
	timeout.emit()
	self.reset()

func _on_puzzle_finished():
	## Signal handler: when a spawned puzzle is complete
	# Mark off the spirit we just finished
	if remaining_spirits.is_empty():
		printerr("tried to mark a puzzle finished when we have none left")
	remaining_spirits.pop_front()
	# If the whole set is done, signal and clean up.
	if remaining_spirits.is_empty():
		all_spirits_summoned.emit()
		canvas.hide()
		self.reset()
		toggle_inputs.emit()
		return
	# We have more spirits to do, spawn the next one
	self._spawn_next_summoning_minigame()

func _on_puzzle_canceled():
	## Signal handler: when a spawned puzzle is canceled
	canvas.hide()
	toggle_inputs.emit()

func _on_player_contact(body: Node2D):
	if !(body is PlayerCharacter):
		return
	## Signal handler: when the player came into contact with our trigger area
	if self.is_active():
		toggle_inputs.emit()
		self._spawn_next_summoning_minigame()
	canvas.show()

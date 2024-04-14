extends Node2D
class_name SummoningMinigame

# NOTE: All minigames should free themselves on completion

## All summoning minigames emit a signal when you complete them successfully.
## This is how we know to decrement that minigame from the list of games required
## for a given summoning point!
signal puzzle_finished

## All summoning minigames can be canceled. If the player does that, this signal
## will fire, but we know not to count it as success.
signal puzzle_canceled

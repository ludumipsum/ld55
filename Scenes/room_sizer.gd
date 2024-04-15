extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_floors_change_floors(to):
	match to:
		0:
			limit_bottom = -38
			limit_top = -164
			limit_left = -288
			limit_right = -52
			zoom = Vector2(5,5)
		1:
			limit_bottom = 208
			limit_top = -164
			limit_left = -363
			limit_right = 257
			zoom = Vector2(2.75,2.75)
		2:
			limit_bottom = 204
			limit_top = -162
			limit_left = -363
			limit_right = 257
			zoom = Vector2(2.75,2.75)
		3:
			limit_bottom = 51
			limit_top = -176
			limit_left = -377
			limit_right = 25
			zoom = Vector2(3,3)

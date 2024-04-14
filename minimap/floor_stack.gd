extends Node3D

@export var floors: Array[Node]
@export var active_floor: int = 0
@export var active_floor_spread: float = 0.4
@export var inactive_floor_spread: float = 0.2

var floor_viewports: Array = []
var floor_textures: Array = []
var floor_quads: Array = []

func change_floor_to(current: int):
	# In 3d worlds, Y is up, in 2d, -Y is up.
	var current_3d = floor_quads.size() - 1 - current
	
	## Spread out the floors in the minimap rendering to show the Nth
	var y_cursor = 0
	var idx = 0
	for quad in floor_quads:
		quad.position.y = y_cursor
		y_cursor += active_floor_spread if (idx == current_3d) else inactive_floor_spread
		idx += 1

func instantiate_floors():
	for floor_root in floors:
		var viewport: Viewport = $FloorViewportPrototype.duplicate()
		add_child(viewport)
		var tex = viewport.get_texture()
		var quad = $FloorQuadPrototype.duplicate()
		add_child(quad)
		quad.visible = true
		quad.material_override = tex
		floor_viewports.push_back(viewport)
		floor_textures.push_back(tex)
		floor_quads.push_back(quad)
		

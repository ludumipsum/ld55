extends Node3D
class_name FloorStack

const OUR_TILEMAP_CELL_SIZE: int = 16

@export var floors: Array[Node]
@export var active_floor: int = 0
@export var active_floor_spread: float = 0.6
@export var inactive_floor_spread: float = 0.2

@onready var shader = load("res://minimap/minimap.gdshader")

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
		# Spawn in a linked camera and viewport to render this floor to
		var viewport = SubViewport.new()
		viewport.transparent_bg = true
		var cam = Camera2D.new()
		cam.custom_viewport = viewport
		
		# Attach the camera and viewport to the floor they're tracking
		floor_root.add_child(viewport)
		floor_root.add_child(cam)
		
		# Get the zoom extents for this floor and:
		# 1. Center the camera over the extents
		# 2. Zoom such that the whole thing is visible
		var zoom_extents = calculate_subtree_extents(floor_root)
		cam.position = zoom_extents.position + (zoom_extents.size)
		viewport.size = zoom_extents.size
		print(zoom_extents)
		
		# Configure the viewport to view the real world
		viewport.world_2d = get_tree().root.get_world_2d()
		
		# Spawn in a quad for rendering this floor in the minimap
		var quad = MeshInstance3D.new()
		floor_quads.push_front(quad)
		add_child(quad)
		
		# Give the quad a mesh to draw to
		var quad_mesh = QuadMesh.new()
		quad_mesh.size = zoom_extents.size.normalized()
		print(zoom_extents.size.normalized())
		quad.mesh = quad_mesh
		
		# Set up the quad's render params to an unlit albedo from the viewport tex
		var material = ShaderMaterial.new()
		quad.material_override = material
		material.shader = shader
		material.set_shader_parameter("viewport_texture", viewport.get_texture())
		
		# Rotate the quad into place to draw nicely on the minimap stack
		quad.rotate_x(deg_to_rad(-60.0))
		#quad.rotate_y(deg_to_rad(45.0))

func calculate_subtree_extents(node: Node):
	## Scan the subtree from the given node, collect all the things with
	## queryable extents, and compute the maximum bounds of those extents
	var base = node.get_used_rect() if node.has_method("get_used_rect") else Rect2(0, 0, 0, 0) 
	base.position *= OUR_TILEMAP_CELL_SIZE
	base.size *= OUR_TILEMAP_CELL_SIZE
	for child in node.get_children():
		base = merge_extents(base, calculate_subtree_extents(child))
	return base
	
func merge_extents(left: Rect2, right: Rect2):
	var min_x = min(left.position.x, right.position.x)
	var min_y = min(left.position.y, right.position.y)
	var max_x = max(left.position.x + left.size.x, right.position.x + right.size.x)
	var max_y = max(left.position.y + left.size.y, right.position.y + right.size.y)
	return Rect2(min_x, min_y, max_x - min_x, max_y - min_y)
	

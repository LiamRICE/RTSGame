extends Node3D

@onready var geometry_data:Node3D = $test_geometry
@onready var mesh_data:MeshInstance3D = $MeshInstance3D

# Called when the node enters the scene tree for the first time.
func _ready():
	run_tests()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func run_tests():
	var meshes = geometry_data.get_children()
	var small_mesh:MeshInstance3D = meshes[0]
	var medium_mesh:MeshInstance3D = meshes[1]
	var complex_mesh:MeshInstance3D = meshes[2]
	
	var mesh:Mesh = small_mesh.mesh
	print(small_mesh)
	print(mesh)
	print(mesh.get_faces())
	print(len(mesh.get_faces()))
	print(mesh.get_surface_count())
	for x in mesh.get_faces():
		print(x)

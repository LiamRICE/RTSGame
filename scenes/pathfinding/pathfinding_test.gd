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
	
	var mdt:MeshDataTool = MeshDataTool.new()
	mdt.create_from_surface(mesh, 0)
	print("Vertex count:",mdt.get_vertex_count())
	print("Vertex faces:",mdt.get_vertex_faces(0))
	print("Face normal:",mdt.get_face_normal(1))
	print("Edge vertex:",mdt.get_edge_vertex(10, 1))
	
	for i in range(mdt.get_vertex_count()):
		var vert = mdt.get_vertex(i)
		vert *= 2.0 # Scales the vertex by doubling size.
		mdt.set_vertex(i, vert)
	
	mesh.clear_surfaces()
	mdt.commit_to_surface(mesh)
	
	
	
	
	
	
	
	
	
	

extends Node3D

@onready var data = $test_geometry

var navmesh_1:NavigationMesh
var navmesh_2:NavigationMesh
var navmesh_3:NavigationMesh

func _ready():
	load_navmeshes()

func load_navmeshes():
	var children = data.get_children()
	navmesh_1 = NavigationMesh.new()
	navmesh_1.create_from_mesh(children[0].mesh)
	
	navmesh_2 = NavigationMesh.new()
	navmesh_2.create_from_mesh(children[1].mesh)
	
	navmesh_3 = NavigationMesh.new()
	navmesh_3.create_from_mesh(children[2].mesh)
	
	print(navmesh_1)
	
	var newmesh:PolyanyaMesh = PolyanyaMesh.generate_mesh_data_from_navmesh(navmesh_1)

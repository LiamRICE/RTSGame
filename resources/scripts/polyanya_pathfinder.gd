extends RefCounted
# calculates pathfinding for a given polyanya mesh using the polyanya algorithm

class_name PolyanyaPathfinder

var mesh:PolyanyaMesh

func initialise(input_mesh:Mesh):
	var navmesh = NavigationMesh.new()
	navmesh.create_from_mesh(input_mesh)
	mesh = PolyanyaMesh.generate_mesh_data_from_navmesh(navmesh)

func get_path(start:Vector3, end:Vector3) -> Array[Vector3]:
	return [start, end]



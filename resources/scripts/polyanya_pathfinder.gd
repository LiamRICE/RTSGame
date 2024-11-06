extends RefCounted
# calculates pathfinding for a given polyanya mesh using the polyanya algorithm

class_name PolyanyaPathfinder

var mesh:PolyanyaMesh

var search_instance:SearchInstance # TODO
var get_path:int = 0
var verbose:int = 0

func initialise(input_mesh:Mesh):
	var navmesh = NavigationMesh.new()
	navmesh.create_from_mesh(input_mesh)
	mesh = PolyanyaMesh.generate_mesh_data_from_navmesh(navmesh)

func run(start:Vector3, end:Vector3) -> Array[Vector3]:
	# initialise search instance
	search_instance = SearchInstance.new()
	search_instance.initialise(mesh)
	# set start point and goal
	
	# start search
	return [start, end]



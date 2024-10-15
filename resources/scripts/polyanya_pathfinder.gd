extends RefCounted
# calculates pathfinding for a given polyanya mesh using the polyanya algorithm

class_name PolyanyaPathfinder

var mesh:PolyanyaMesh

func get_path(start:Vector3, end:Vector3) -> Array[Vector3]:
	return [start, end]



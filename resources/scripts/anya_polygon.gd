extends RefCounted

class_name AnyaPolygon

var id:int = -1
var vertices:Array[int] = []
var neighbours:Array[AnyaPolygon] = []
var cost:float = 1

static func new_polygon(vtx:Array[int], id:int) -> AnyaPolygon:
	var polygon = AnyaPolygon.new()
	polygon.id = id
	polygon.vertices.append_array(vtx)
	return polygon

func is_touching(polygon:AnyaPolygon) -> bool:
	var result_count = 0
	for vertex in vertices:
		if polygon.vertex_in_polygon(vertex) and not polygon == self:
			result_count += 1
	return result_count > 1

func vertex_in_polygon(vertex:int) -> bool:
	return vertex in vertices

func get_neighbour(point_a:int, point_b:int) -> AnyaPolygon:
	var final:AnyaPolygon = null
	var found:bool = false
	var i:int = 0
	while not found:
		found = neighbours[i].vertex_in_polygon(point_a) and neighbours[i].vertex_in_polygon(point_b)
		if found:
			final = neighbours[i]
		i+=1
		
	return final

func get_neighbour_polygons_in_mesh(mesh_polygons:Array[AnyaPolygon]):
	for polygon in mesh_polygons:
		if is_touching(polygon):
			neighbours.append(polygon)

func _to_string():
	return str(id)+" : "+str(vertices)

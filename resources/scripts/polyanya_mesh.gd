extends RefCounted
# this function contains data and functions for a polyanya mesh

class_name PolyanyaMesh

var vertices:Array[Vector3] = []
var polygons:Array[AnyaPolygon] = []

static func generate_mesh_data_from_navmesh(navmesh:NavigationMesh) -> PolyanyaMesh:
	var polyanya_mesh = PolyanyaMesh.new()
	# add vertexes to polyanya mesh
	var vertices:PackedVector3Array = navmesh.get_vertices()
	polyanya_mesh.vertices.append_array(vertices)
	# add polygons
	var num_polygons:int = navmesh.get_polygon_count()
	for i in range(0, num_polygons):
		var polygon_vertex_ids = navmesh.get_polygon(i)
		polyanya_mesh.polygons.append(AnyaPolygon.new_polygon(polygon_vertex_ids, i))
	# set polygon neighbour indices
	for polygon in polyanya_mesh.polygons:
		polygon.get_neighbour_polygons_in_mesh(polyanya_mesh.polygons)
	return polyanya_mesh

func get_vertices(polygon:AnyaPolygon) -> Array[Vector3]:
	var poly_vertices:Array[Vector3] = []
	for vertex in polygon.vertices:
		poly_vertices.append(vertices[vertex])
	return poly_vertices

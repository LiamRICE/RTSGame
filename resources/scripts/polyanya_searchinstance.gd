extends RefCounted
# calculates pathfinding for a given polyanya mesh using the polyanya algorithm

class_name SearchInstance

var mesh:PolyanyaMesh
var start:Vector3
var goal:Vector3
var final_node:Vector3
var end_polygon:int
var nodes_popped:int

var open_list:Array

func initialise(navmesh:PolyanyaMesh):
	mesh = navmesh

func set_search_params(start:Vector3, goal:Vector3):
	self.start = start
	self.goal = goal
	self.final_node = null

func init_search():
	pass

func search():
	init_search() # TODO - implement
	if self.mesh == null or end_polygon == -1:
		return false
	if final_node != null:
		return true
	
	while len(open_list) > 0:
		var node = open_list.pop()
		#ifndef NDEBUG
		if verbose:
			print("popped off: ", node)
		#endif

		nodes_popped += 1
		var next_poly:int = node.next_polygon # TODO - implement node system?
		if next_poly == end_polygon:
			# make this the true final node
			# we need to find wheter we need to turn left or right to reach the goal, so we do an orientation check
			pass

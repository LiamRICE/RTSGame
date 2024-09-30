class_name CustomAStar3D extends AStar3D


# Called when the node enters the scene tree for the first time.
func _compute_cost(from_id, to_id)->float:
	return get_point_position(from_id).distance_squared_to(get_point_position(to_id))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _estimate_cost(from_id, to_id)->float:
	return get_point_position(from_id).distance_squared_to(get_point_position(to_id))

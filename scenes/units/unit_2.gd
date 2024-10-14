extends CharacterBody3D

class_name Unit2

# Nodes
@onready var selection_sprite :Sprite3D = $Selected

# Constants
@export var SPEED :float
@export var ACCELERATION :float
@export var ROTATION_SPEED :float
@export var TEAM: int

# Flags
@export var is_tracked :bool
var is_navigating :bool = false

# Variables
var facing :Vector3

# Navigation veriables
var debug_path = preload("res://assets/debug/visualisation_node.tscn")
var query_parameters := NavigationPathQueryParameters3D.new()
var query_result := NavigationPathQueryResult3D.new()
var path:PackedVector3Array
var path_index:int = 0
var path_distance_cutoff:float = 10
var is_navigation_finished: bool = true

# Ready is called once for the node when it joins the scene tree
func _ready():
	deselect()
	set_values()


# Physics process is called at fixed intervals (60Hz)
func _physics_process(_delta):
	if is_navigation_finished:
		is_navigating = false
	if is_navigating:
		calculate_unit_transform()
		move_and_slide()
	else:
		velocity = velocity.move_toward(Vector3.ZERO, 1.5)
		move_and_slide()


func show_path(path:PackedVector3Array):
	print("Printing path...")
	for point in path:
		print(point)
		var path_node:Node3D = debug_path.instantiate()
		path_node.global_transform.origin = get_position()
		get_parent().add_child(path_node)



func query_path(p_start_position: Vector3, p_target_position: Vector3, p_navigation_layers: int = 1) -> PackedVector3Array:
	if not is_inside_tree():
		return PackedVector3Array()

	query_parameters.map = get_world_3d().get_navigation_map()
	query_parameters.start_position = p_start_position
	query_parameters.target_position = p_target_position
	query_parameters.navigation_layers = p_navigation_layers

	NavigationServer3D.query_path(query_parameters, query_result)
	var path: PackedVector3Array = query_result.get_path()

	return path
	


func get_next_path_position() -> Vector3:
	# if arrived at previous point, direction to next point
	var target = path[path_index]
	var direction:Vector3 = target
	# if distance to next point is short enough, move to next point
	var distance:float = global_transform.origin.distance_to(target)
	if distance < path_distance_cutoff:
		path_index += 1
	# if no next point, navigation finished
	if path_index >= len(path):
		is_navigation_finished = true
	return direction


# Calculates and applies the transforms of the object for path-following
func calculate_unit_transform() -> void:
	# Fetch the current location from the objects global transform
	var current_location = global_transform.origin
	# Get the goal location of the next position in the path
	
	var next_location = get_next_path_position()
	# Calculate the direction from the current position to the goal position that the object needs to turn towards
	var commanded_direction = current_location.direction_to(next_location)
	
	# TODO - Add a command so that the facing of a vehicle can be modified
	# Ex : rotation when it arrives at it's target destination
	facing = commanded_direction
	
	# saves the current rotation quaternion then looks at the target and sets the target quaternion
	var target_rotation = Quaternion(Basis.looking_at(facing)).normalized()
	
	# Rotates the object by spherical interpolation towards the facing the unit is targeting
	self.quaternion = rotate_towards(self.quaternion, target_rotation, ROTATION_SPEED)
	
	# Calculate the dot product to the current target direction
	var direction_closeness = transform.basis.x.dot(commanded_direction)
	
	# If the unit facing is close to the commanded direction, increase speed until it is at max speed
	if abs(direction_closeness) < 0.4:
		velocity = velocity.move_toward(-transform.basis.z * SPEED, 1)
	elif abs(direction_closeness) > 0.4 and not velocity.is_zero_approx():
		velocity = velocity.move_toward(Vector3.ZERO, 0.5)
	else:
		velocity = velocity.move_toward(Vector3.ZERO, 1.5)


# Rotates quaternion A towards quaternion B at a fixed angular velocity
func rotate_towards(a: Quaternion, b: Quaternion, angle: float) -> Quaternion:
	var angle_to: float = a.angle_to(b)
	if angle_to > angle:
		return a.slerp(b, angle/angle_to)
	else:
		return b;


# Updates the pathfinding target location
# TODO - Create a NavigationServer3D implementation of the path request using the navigation maps
func update_target_location(target_location:Vector3):
	path = query_path(global_transform.origin, target_location)
	show_path(path)
	path_index = 0
	is_navigating = true
	is_navigation_finished = false


# TODO - DEBUG : remove when units are defined
func set_values() -> void:
	SPEED = 100
	ROTATION_SPEED = 0.05
	ACCELERATION = 0.5
	TEAM = 1

func select() -> void:
	selection_sprite.visible = true


# Sets the visibility of the selection sprite of the unit to false
func deselect() -> void:
	selection_sprite.visible = false

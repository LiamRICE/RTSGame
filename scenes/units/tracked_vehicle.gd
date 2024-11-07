extends Unit

class_name TrackedVehicle

#@export var ROTATION_SPEED: float = 0.5 # speed in radians/sec

@onready var turret = $Turret
var TURRET_ROTATION_SPEED
var target:Vector3 = Vector3.ZERO

func set_values() -> void:
	SPEED = 50.0
	ROTATION_SPEED = .05
	ACCELERATION = 0.1
	TURRET_ROTATION_SPEED = 0.1
	TEAM = 1


# Ready is called once for the node when it joins the scene tree
func _ready():
	deselect()
	set_values()


# Physics process is called at fixed intervals (60Hz)
func _physics_process(_delta):
	# movement
	if nav_agent.is_navigation_finished():
		is_navigating = false
	if is_navigating:
		calculate_unit_transform()
		move_and_slide()
	else:
		velocity = velocity.move_toward(Vector3.ZERO, 1.5)
		move_and_slide()
	
	# targeting
	point_to_target()


func point_to_target():
	if target != null:
		var current_location = turret.transform.origin
		var commanded_direction = current_location.direction_to(target)
		var target_rotation = Quaternion(Basis.looking_at(commanded_direction)).normalized()
		turret.quaternion = rotate_towards(self.quaternion, target_rotation, ROTATION_SPEED)


# Calculates and applies the transforms of the object for path-following
func calculate_unit_transform() -> void:
	# Fetch the current location from the objects global transform
	var current_location = global_transform.origin
	# Get the goal location of the next position in the path
	var next_location = nav_agent.get_next_path_position()
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
	nav_agent.target_position = target_location
	is_navigating = true


func select() -> void:
	selection_sprite.visible = true


# Sets the visibility of the selection sprite of the unit to false
func deselect() -> void:
	selection_sprite.visible = false


# this function decides how the unit moves towards it's next navigation point
func get_unit_velocity(delta) -> void:
	# STEP 1 - rotate to correct direction
	var current_direction = global_basis.x # get current facing direction
	var next_location = nav_agent.get_next_path_position()
	var next_direction = global_position.direction_to(next_location).normalized()
	# calculate angle to turn
	var v1 = Vector2(current_direction.x, current_direction.z)
	var v2 = Vector2(next_direction.x, next_direction.z)
	var to_angle = atan2(v2.y,v2.x) - atan2(v1.y,v1.x)
	# correct weird angle behaviour
	if to_angle > PI:
		to_angle = -to_angle + PI
	elif to_angle < -PI:
		to_angle = -to_angle - PI
	if to_angle > 0.1:
		global_rotate(Vector3.UP, -ROTATION_SPEED * delta)
	elif to_angle < -0.1:
		global_rotate(Vector3.UP, ROTATION_SPEED * delta)
	
	# STEP 2 - move forward
	# check if facing is correct
	if to_angle > -0.5 or to_angle < 0.5:
		# allow movement
		var new_velocity = current_direction * SPEED
		new_velocity.y = next_direction.y
		velocity = velocity.move_toward(new_velocity, ACCELERATION)
	move_and_slide()
	#var current_location = global_transform.origin
	#var current_direction = global_transform.basis
	#var next_location = nav_agent.get_next_path_position()
	## get necessary rotation
	#var necessary_rotation:float = current_direction.x.angle_to(next_location)
	## rotate towards target
	#var partial_rotation = move_toward(0, necessary_rotation, ROTATION_SPEED)
	#rotate(Vector3.UP, partial_rotation)
	#print(partial_rotation)
	#if necessary_rotation < 1 or necessary_rotation > -1:
		## move towards target
		#var new_velocity = (next_location - current_location).normalized() * SPEED * delta * SPEED_MULT
		#velocity = velocity.move_toward(new_velocity, .1)

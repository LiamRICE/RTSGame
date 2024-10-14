extends Node3D

@onready var geometry_data:Node3D = $test_geometry
@onready var mesh_data:MeshInstance3D = $MeshInstance3D

# Called when the node enters the scene tree for the first time.
func _ready():
	run_tests()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func run_tests():
	pass

extends Node3D

# Nodes
@onready var marker :DeploymentMarker = $DeploymentMarker

# Navigation structures
var navigation_maps_RID :Dictionary = {}
@export var navigation_regions :Dictionary


func _on_player_interface_spawn_unit(unit: UnitSpawn):
	print("Adding unit to deployment buffer.")
	# find closest deployment marker
	marker.queue_unit(unit)


func _ready() -> void:
	call_deferred("_initialise_navigation_server")


func _initialise_navigation_server() -> void:
	# Initialise the ground, water and air navigation maps
	navigation_maps_RID["ground"] = NavigationServer3D.get_maps()[0]
	navigation_maps_RID["water"] = NavigationServer3D.map_create()
	navigation_maps_RID["air"] = NavigationServer3D.map_create()
	
	# Set the cell size and cell height for each navigation map
	NavigationServer3D.map_set_cell_size(navigation_maps_RID["ground"], 0.25)
	NavigationServer3D.map_set_cell_size(navigation_maps_RID["water"], 0.25)
	NavigationServer3D.map_set_cell_size(navigation_maps_RID["air"], 0.25)
	
	NavigationServer3D.map_set_cell_height(navigation_maps_RID["ground"], 0.25)
	NavigationServer3D.map_set_cell_height(navigation_maps_RID["water"], 0.25)
	NavigationServer3D.map_set_cell_height(navigation_maps_RID["air"], 0.25)
	
	# load the navigation regions and add them to the maps
	#var forest_region :NavigationRegion3D = $multi_nav_test/forest
	#var road_region :NavigationRegion3D = $multi_nav_test/road
	var grass_region :NavigationRegion3D = $test_map_1/map_1_mesh_04_decimation
	var river_region :NavigationRegion3D = $test_map_1/map_1_rivers_navmesh
	#var air_region :NavigationRegion3D = $multi_nav_test/air
	
	# Modify regions
	# TODO - modify region parameters for navigation
	
	# Assign the regions to their respective maps
	NavigationServer3D.region_set_map(river_region, navigation_maps_RID["water"])
	NavigationServer3D.region_set_map(grass_region, navigation_maps_RID["ground"])
	
	# Activates the maps
	NavigationServer3D.map_set_active(navigation_maps_RID["ground"], true)
	NavigationServer3D.map_set_active(navigation_maps_RID["water"], true)
	













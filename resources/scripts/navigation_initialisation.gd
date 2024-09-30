extends Node3D

# Navigation parameters
@export var GRASS_COST :float = 1
@export var FOREST_COST :float = 5
@export var ROAD_COST :float = 0.1
@export var WATER_COST :float = 3

# Navigation Server Data
var navigation_maps_RID :Dictionary = {}


# Called when the node enters the scene tree for the first time.
func _ready():
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
	for region in self.get_children():
		if region.get_child_count() > 0:
			if region.get_child(0) is NavigationRegion3D:
				region = region.get_child(0)
		if region is NavigationRegion3D :
			region.set_navigation_layer_value(1, false)
			if region.name.contains("Road"):
				NavigationServer3D.region_set_map(region.get_rid(), navigation_maps_RID["ground"])
				region.set_navigation_layer_value(7, true)
				region.set_enter_cost(0)
				region.set_travel_cost(ROAD_COST)
			if region.name.contains("Forest"):
				NavigationServer3D.region_set_map(region.get_rid(), navigation_maps_RID["ground"])
				region.set_navigation_layer_value(6, true)
				region.set_enter_cost(0)
				region.set_travel_cost(FOREST_COST)
			if region.name.contains("grass"):
				NavigationServer3D.region_set_map(region.get_rid(), navigation_maps_RID["ground"])
				region.set_navigation_layer_value(1, true)
				region.set_enter_cost(0)
				region.set_travel_cost(GRASS_COST)
			if region.name.contains("amphibious"):
				NavigationServer3D.region_set_map(region.get_rid(), navigation_maps_RID["ground"])
				region.set_navigation_layer_value(8, true)
				region.set_enter_cost(0)
				region.set_travel_cost(WATER_COST)
	
	# Activates the maps
	NavigationServer3D.map_set_active(navigation_maps_RID["ground"], true)
	#NavigationServer3D.map_set_active(navigation_maps_RID["water"], true)

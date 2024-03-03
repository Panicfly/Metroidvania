extends TileMap

@export var noise_height_texture : NoiseTexture2D

var noise : Noise
var width : int = 200
var height : int = 200

var source_id = 0
var nothing_atlas = Vector2i(0, 4)
var floor_atlas = Vector2i(1, 0)
var terrain_floor_int = 0

#TileMap Layers
var background_layer = 0
var floor_layer = 1

var noise_value_array = []
var floor_tiles_array = []

@onready var world_tile_map = $"."

func _ready():
	noise = noise_height_texture.noise
	generate_world()

func generate_world():
	for x in range(-width/2.0, width/2.0):
		for y in range(-height/2.0, height/2.0):
			var noise_value = noise.get_noise_2d(x,y)
			if noise_value >= 0.0:
				floor_tiles_array.append(Vector2i(x,y))
			#elif noise_value < 0.0:
			world_tile_map.set_cell(background_layer, Vector2(x, y), source_id, nothing_atlas)
				
			#print(noise_value)
			#noise_value_array.append(noise_value)
	world_tile_map.set_cells_terrain_connect(floor_layer, floor_tiles_array, terrain_floor_int, 0)
	
	#print("highest: ", noise_value_array.max())
	#print("lowest: ", noise_value_array.min())

extends Node

#PATH FOR TESTING THE SAVE FILE SYSTEM
const TEST_PATH = "res://save.txt"
const PRODUCTION_PATH = "user://planetwalker_save.save"

var save_path = TEST_PATH
var is_loading = false

func save_game():
	var start = Time.get_ticks_usec()
	WorldStash.stash_data("level", "level_path", MainInstances.level.scene_file_path)
	WorldStash.stash_data("player", "player_location_x", MainInstances.player.global_position.x)
	WorldStash.stash_data("player", "player_location_y", MainInstances.player.global_position.y)
	PlayerStats.stash_stats()

	#If there is no file it will automatically create one
	var save_file = FileAccess.open(save_path, FileAccess.WRITE)
	var world_stash_data_string = JSON.stringify(WorldStash.data)
	save_file.store_string(world_stash_data_string)
	save_file.close()
	var end = Time.get_ticks_usec()
	var save_time = (end-start)/1000000.0
	print("Save Function Time:", save_time)

func load_game():
	var save_file = FileAccess.open(save_path, FileAccess.READ)
	if not save_file is FileAccess: return null

	var world_stash_data = JSON.parse_string(save_file.get_line())
	WorldStash.data = world_stash_data

	var file_path = WorldStash.retrieve_data("level", "level_path")
	MainInstances.world.load_level(file_path)
	var playerx = WorldStash.retrieve_data("player", "player_location_x")
	var playery = WorldStash.retrieve_data("player", "player_location_y")
	MainInstances.player.global_position = Vector2(playerx, playery)

	PlayerStats.retrieve_stats()
	save_file.close()

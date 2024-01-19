extends Node

#PATH FOR TESTING THE SAVE FILE SYSTEM
const TEST_PATH = "res://save.txt"
const PRODUCTION_PATH = "user://planetwalker_save.save"

var save_path = TEST_PATH

func save_game():
	WorldStash.stash_data("level", "level_path", MainInstances.level.scene_file_path)
	
	#If there is no file it will automatically create one
	var save_file = FileAccess.open(save_path, FileAccess.WRITE)
	var world_stash_data_string = JSON.stringify(WorldStash.data)
	save_file.store_string(world_stash_data_string)
	save_file.close()

func load_game():
	var save_file = FileAccess.open(save_path, FileAccess.READ)
	if not save_file is FileAccess: return null
	
	var world_stash_data = JSON.parse_string(save_file.get_line())
	WorldStash.data = world_stash_data
	save_file.close()

extends Node

#dictionary for saving key value pairs
var data = {}

func get_id(node):
	var level = MainInstances.level
	return level.name + "_" + node.name + "_" + str(node.global_position)
	#Example Level_2_MissilePowerup_32,16

func stash_data(id, key, value):
	if not data.has(id): data[id] = {}
	data[id][key] = value
	#print(data)

func retrieve_data(id, key):
	if not data.has(id): return
	if not data[id].has(key): return
	return data[id][key]

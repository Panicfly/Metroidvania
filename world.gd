extends Node2D

@onready var level: = $Level1

# Called when the node enters the scene tree for the first time.
func _ready():
	RenderingServer.set_default_clear_color(Color.BLACK)
	Events.door_entered.connect(change_level)

func change_level(door : Door):
	var player = MainInstances.player as Player
	if not player is Player: return
	#Godot Group function helps us to find the right door even if we have multiple doors in one level
	level.queue_free()
	var new_level = load(door.new_level_path).instantiate()
	add_child(new_level)
	level = new_level
	#Array of all of the Group Nodes in doors
	var doors = get_tree().get_nodes_in_group("doors")
	for found_door in doors:
		#If the door found is the door we came through we don't want it and continue
		#We also we check if the door connections match
		if found_door == door: continue
		if found_door.connection != door.connection: continue
		var yoffset = player.global_position.y - door.global_position.y
		#Offset for correcting the position of the player when entering through doors
		player.global_position = found_door.global_position + Vector2(0, yoffset)

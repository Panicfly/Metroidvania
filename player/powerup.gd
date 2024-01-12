class_name Powerup
extends Area2D

func _ready():
	#Wait a single frame before it runs the code so world.level is loaded
	await get_tree().process_frame
	var id = WorldStash.get_id(self)
	var freed = WorldStash.retrieve_data(id, "freed")
	if freed: queue_free()

func pick_up():
	var id = WorldStash.get_id(self)
	WorldStash.stash_data(id, "freed", true)
	queue_free()

func _on_body_entered(_body):
	pick_up()

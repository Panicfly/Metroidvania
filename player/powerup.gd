class_name Powerup
extends Area2D

func _ready():
	var id = WorldStash.get_id(self)
	var freed = WorldStash.retrieve_data(id, "freed")
	if freed: queue_free()

func pick_up():
	Sound.play(Sound.powerup, 1.0, -15.0)
	var id = WorldStash.get_id(self)
	WorldStash.stash_data(id, "freed", true)
	queue_free()

func _on_body_entered(_body):
	pick_up()

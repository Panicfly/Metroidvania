extends Stats

@export var max_missiles = 0 : set = set_max_missiles

@onready var missiles = max_missiles : set = set_missiles
@onready var starting_max_health = max_health
@onready var starting_max_missiles = max_missiles

signal max_missiles_changed
signal missiles_changed

func set_max_missiles(value):
	max_missiles = value
	max_missiles_changed.emit()

func set_missiles(value):
	missiles = clampi(value, 0, max_missiles)
	missiles_changed.emit()

func refill_stats():
	health = max_health
	missiles = max_missiles

func reset_stats():
	max_health = starting_max_health
	max_missiles = starting_max_missiles
	refill_stats()

func stash_stats():
	WorldStash.stash_data("player", "max_health", max_health)
	WorldStash.stash_data("player", "max_missiles", max_health)

func retrieve_stats():
	max_health = WorldStash.retrieve_data("player", "max_health")
	max_missiles = WorldStash.retrieve_data("player", "max_missiles")
	refill_stats()

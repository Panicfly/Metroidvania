extends Control

@onready var empty = $Empty
@onready var full = $Full

func _ready():
	update_health_bar()
	update_max_health_bar()
	PlayerStats.health_changed.connect(update_health_bar)
	PlayerStats.max_health_changed.connect(update_max_health_bar)

func update_health_bar():
	full.size.x = PlayerStats.health * 5 + 1 

func update_max_health_bar():
	empty.size.x = PlayerStats.max_health * 5 + 1

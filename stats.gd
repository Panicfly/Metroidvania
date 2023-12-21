class_name Stats
extends Node

@export var max_health = 3 : set = set_max_health
#@onready helps to load the correct changed max_health for the health var 
@onready var health = max_health : set = set_health

signal no_health
signal health_changed
signal max_health_changed

func set_max_health(value):
	max_health = value
	max_health_changed.emit()

func set_health(value):
	#clamp() keeps the health value in the area between 0 and max_health
	health = clamp(value, 0, max_health)
	health_changed.emit()
	if health <= 0:
		no_health.emit()

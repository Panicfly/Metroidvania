extends "res://effects/effect.gd"

func _ready():
	super()
	Sound.play(Sound.explosion, 1.0, -10)

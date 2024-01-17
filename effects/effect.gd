extends AnimatedSprite2D

func _ready():
	#No parentheses on queue_free so the function is not called immediately
	animation_finished.connect(queue_free)
	Sound.play(Sound.explosion, 1.0, -4.0)

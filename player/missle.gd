extends Projectile

func _ready():
	#Sound.play(Sound.explosion, 1.0, 5.0)
	pass

func _on_hitbox_body_entered(body):
	super(body)
	Sound.play(Sound.explosion, 1.0, 5.0)
	Events.add_screenshake.emit(2, 0.3)
	if body is Brick:
		body.queue_free()

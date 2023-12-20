class_name Hurtbox
extends Area2D

var is_invincible = false:
	set(value):
		is_invincible = value
		#Call_deferred is needed because while the physics are working you can't disable a CollisionShape
		#Deferred is waiting
		disable.call_deferred(value)

signal hurt(hitbox, damage)

func take_hit(hitbox, damage):
	if is_invincible: return
	hurt.emit(hitbox, damage)

func disable(value):
	for child in get_children():
		if child is CollisionShape2D or child is CollisionPolygon2D:
			child.disabled = value

class_name Powerup
extends Area2D

func pick_up():
	queue_free()

func _on_body_entered(_body):
	pick_up()

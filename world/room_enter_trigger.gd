extends Area2D

var trigger_active = true

signal trigger_room_entered

func _on_body_entered(_body):
	if not trigger_active: return
	trigger_room_entered.emit()

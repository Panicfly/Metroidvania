class_name Door
extends Area2D

var active = false
#For setting the path of the new level we wanna go to
@export_file("*.tscn") var new_level_path
@export var connection : DoorConnection

func _physics_process(_delta):
	var player = MainInstances.player as Player
	if not player is Player: return
	#Prevents a bug where you skip a level when 2 doors are on the same position
	if not active: return
	if overlaps_body(player) and new_level_path and Input.is_action_just_pressed("up"):
		Events.door_entered.emit(self)

func _on_timer_timeout():
	active = true

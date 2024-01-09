class_name Door
extends Area2D

@export_file("*.tscn") var new_level_path
@export var connection : DoorConnection

@onready var right_cast = $RightCast
@onready var left_cast = $LeftCast

func get_direction():
	if left_cast.is_colliding():
		return -1
	if right_cast.is_colliding():
		return 1
	return 0

func _physics_process(_delta):
	var player = MainInstances.player as Player
	if not player is Player : return
	if overlaps_body(player) and new_level_path and Input.is_action_just_pressed("up"):
		#var player_access_direction = sign(player.velocity.x)
		#var direction = get_direction()
		Events.door_entered.emit(self)
		#if player_access_direction == direction:
			#print("Door entered")
			#Events.door_entered.emit(self)

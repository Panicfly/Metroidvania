extends Node2D

@export var waypoint_buffer_distance = 8

var waypoints = []
var target: Node2D
var pathfinding_next_postition: Vector2

@onready var ray_cast_2d = $RayCast2D

func _physics_process(_delta):
	if not MainInstances.player is Node2D: return
	target = MainInstances.player.center
	
	if can_see_target(global_position):
		pathfinding_next_postition = target.global_position
		waypoints.clear()
	else:
		if not waypoints.is_empty():
			pathfinding_next_postition = waypoints.front()
			#Fills the waypoints array with the global position of the player if it cannot see the player from the last waypoint
			if not can_see_target(waypoints.back()):
				waypoints.append(target.global_position)
				
			#Removes waypoint when close to it
			if global_position.distance_to(waypoints.front()) <= waypoint_buffer_distance:
				waypoints.pop_front()
				
		else:
			#if the waypoints are empty the first waypoint is created by the global position of the player
			if not can_see_target(global_position):
				waypoints.append(target.global_position)

func can_see_target(from):
	ray_cast_2d.global_position = from
	ray_cast_2d.target_position = target.global_position - from
	ray_cast_2d.force_raycast_update()
	return not ray_cast_2d.is_colliding()

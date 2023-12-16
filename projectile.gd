class_name Projectile
extends Node2D

@export var speed = 250
#Speed and direction of the projectile
var velocity = Vector2.ZERO

func update_velocity():
	velocity.x = speed
	velocity = velocity.rotated(rotation)

func _process(delta):
	position += velocity * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_hitbox_body_entered(body):
	var world = get_tree().current_scene
	var player = world.get_node("Player")
	if body != player:
		queue_free()
	
func _on_hitbox_area_entered(_area):
	queue_free()

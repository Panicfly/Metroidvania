extends Node2D

const BULLET_SCENE = preload("res://player/bullet.tscn")

@onready var blaster_sprite = $BlasterSprite
@onready var muzzle = $BlasterSprite/Muzzle

func _process(delta):
	blaster_sprite.rotation = get_local_mouse_position().angle()

func fire_bullet():
	var bullet = Utils.instantiate_scene_on_world(BULLET_SCENE, muzzle.global_position)
	bullet.rotation = blaster_sprite.rotation
	bullet.update_velocity()

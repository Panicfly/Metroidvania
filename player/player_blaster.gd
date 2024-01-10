extends Node2D

const BULLET_SCENE = preload("res://player/bullet.tscn")
const MISSILE_SCENE = preload("res://player/missle.tscn")

@onready var blaster_sprite = $BlasterSprite
@onready var muzzle = $BlasterSprite/Muzzle

func _process(_delta):
	blaster_sprite.rotation = get_local_mouse_position().angle()

func fire_bullet():
	var bullet = Utils.instantiate_scene_on_level(BULLET_SCENE, muzzle.global_position)
	bullet.rotation = blaster_sprite.rotation
	bullet.update_velocity()

func fire_missile():
		var missile = Utils.instantiate_scene_on_level(MISSILE_SCENE, muzzle.global_position)
		missile.rotation = blaster_sprite.rotation
		missile.update_velocity()

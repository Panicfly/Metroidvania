extends Node2D

const ENEMY_BULLET_SCENE = preload("res://enemies/enemy_bullet.tscn")
const ENEMY_DEATH_EFFECT_SCENE = preload("res://effects/enemy_death_effect.tscn")

@export var bullet_speed = 30
@export var spread = 45

@onready var stats = $Stats
@onready var bullet_spawn_point = $BulletSpawnPoint
@onready var fire_direction = $FireDirection
@onready var death_effect_location = $DeathEffectLocation

func fire_bullet():
	var bullet = Utils.instantiate_scene_on_level(ENEMY_BULLET_SCENE, bullet_spawn_point.global_position) as Projectile
	var direction = global_position.direction_to(fire_direction.global_position)
	var velocity = direction.normalized() * bullet_speed
	@warning_ignore("integer_division")
	velocity = velocity.rotated(randf_range(-deg_to_rad(spread / 2), deg_to_rad(spread / 2)))
	bullet.velocity = velocity

func _on_hurtbox_hurt(_hitbox, damage):
	stats.health -= damage
	
func _on_stats_no_health():
	Utils.instantiate_scene_on_level(ENEMY_DEATH_EFFECT_SCENE, death_effect_location.global_position)
	queue_free()

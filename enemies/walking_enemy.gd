extends CharacterBody2D

const ENEMY_DEATH_EFFECT_SCENE = preload("res://effects/enemy_death_effect.tscn")

@export var speed = 40.0
@export var turns_at_ledges = true

var gravity = 600.0
var direction = 1.0
@onready var sprite_2d = $Sprite2D
@onready var floor_cast = $FloorCast
@onready var stats = $Stats
@onready var death_effect_location = $DeathEffectLocation

func _physics_process(delta):
	if not is_on_floor():
		#Changing the velocity = with delta
		velocity.y += gravity * delta
	
	if is_on_wall():
		turn_around()
	
	if is_at_ledge() and turns_at_ledges:
		turn_around()
	
	sprite_2d.scale.x = direction
	#Setting velocity = without delta
	velocity.x = direction * speed
	
	move_and_slide()

func is_at_ledge():
	return is_on_floor() and not floor_cast.is_colliding()

func turn_around():
	direction *= -1.0

func _on_hurtbox_hurt(_hitbox, damage):
	stats.health -= damage

func _on_stats_no_health():
	Utils.instantiate_scene_on_level(ENEMY_DEATH_EFFECT_SCENE, death_effect_location.global_position)
	queue_free()

extends Node2D

const ENEMY_DEATH_EFFECT_SCENE = preload("res://effects/enemy_death_effect.tscn")

enum DIRECTION {LEFT = -1, RIGHT = 1}

@export var max_speed = 300
@export var gravity = 80
@export var spin_speed_multiplier = 4
@export var crawling_direction = DIRECTION.RIGHT

var state = crawling_state

@onready var floor_cast = $FloorCast
@onready var wall_cast = $WallCast
@onready var stats : Stats = $Stats
@onready var animated_sprite_2d = $AnimatedSprite2D

func _ready():
	#WallCast has to point in the right direction left or right depending on the crawling_direction
	wall_cast.target_position.x *= crawling_direction

func _physics_process(delta):
	state.call(delta)

func crawling_state(delta):
	animated_sprite_2d.play("crawl")
	if wall_cast.is_colliding():
		global_position = wall_cast.get_collision_point()
		var wall_normal = wall_cast.get_collision_normal() #Normal is a vector pointing away from the collision
		rotation = wall_normal.rotated(deg_to_rad(90)).angle()
	else:
		floor_cast.rotation_degrees = -max_speed * crawling_direction * delta
		
		var trying_limit = 30
		while not floor_cast.is_colliding():
			rotation_degrees += crawling_direction
			floor_cast.force_raycast_update()
			trying_limit -= 1
			if trying_limit <= 0:
				state = falling_state
				break
		
		if floor_cast.is_colliding():
			global_position = floor_cast.get_collision_point()
			var floor_normal = floor_cast.get_collision_normal()
			rotation = floor_normal.rotated(deg_to_rad(90)).angle()

func falling_state(delta):
	animated_sprite_2d.play("fall")
	rotation_degrees += crawling_direction * max_speed * delta * spin_speed_multiplier
	position.y += gravity * delta
	if floor_cast.is_colliding() or wall_cast.is_colliding():
		state = crawling_state

func _on_hurtbox_hurt(_hitbox, damage):
	stats.health -= damage

func _on_stats_no_health():
	Utils.instantiate_scene_on_level(ENEMY_DEATH_EFFECT_SCENE, global_position)
	queue_free()

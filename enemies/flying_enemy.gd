extends CharacterBody2D

const ENEMY_DEATH_EFFECT_SCENE = preload("res://effects/enemy_death_effect.tscn")

@export var acceleration = 100
@export var max_speed = 40

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var stats = $Stats
@onready var waypoint_pathfinding = $WaypointPathfinding
@onready var visible_on_screen_notifier_2d = $VisibleOnScreenNotifier2D

func _ready():
	set_physics_process(false)

func _physics_process(delta):
	var player = MainInstances.player
	if player is CharacterBody2D:
		move_toward_position(waypoint_pathfinding.pathfinding_next_postition, delta)

func move_toward_position(target_position, delta):
	var direction = global_position.direction_to(target_position)
	velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
	animated_sprite_2d.flip_h = global_position < target_position
	move_and_slide()

func _on_hurtbox_hurt(_hitbox, damage):
	stats.health -= damage

func _on_stats_no_health():
	Utils.instantiate_scene_on_level(ENEMY_DEATH_EFFECT_SCENE, global_position)
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_entered():
	set_physics_process(true)

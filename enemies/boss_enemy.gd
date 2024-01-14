extends Node2D

const STINGER_SCENE = preload("res://enemies/stinger.tscn")

@export var acceleration = 200
@export var max_speed = 800
@export var targets: Array[NodePath]

var state = rush_state
var velocity = Vector2.ZERO

@onready var stats = $Stats
@onready var stinger_pivot_point = $StingerPivotPoint
@onready var muzzle = $StingerPivotPoint/Muzzle
@onready var stinger_shooting_timer = $StingerShootingTimer
@onready var attack_timer = $AttackTimer

func _process(delta):
	state.call(delta)

func rush_state(delta):
	var player = MainInstances.player
	if not player is Player: return
	var direction = global_position.direction_to(player.global_position)
	velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
	move(delta)

func shooting_state(delta):
	if stinger_shooting_timer.time_left == 0:
		stinger_pivot_point.rotation_degrees += 18
		stinger_shooting_timer.start()
		var stinger = Utils.instantiate_scene_on_level(STINGER_SCENE, muzzle.global_position)
		stinger.rotation = stinger_pivot_point.rotation
		stinger.update_velocity()

func recenter_state(delta):
	#Error Message target_is empty if the markes are not assigned
	assert(not targets.is_empty())
	set_process(false)
	#This will get one random node out of our array of targets
	var center_node = get_node(targets.pick_random())
	#A tween is a process which has only to be called once and not every process frame. It does his job and stops
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	#Object of Change in this case Self = Boss Node, Attribut of change, to what it should get changed to, the time for the change
	tween.tween_property(self, "global_position", center_node.global_position, 2.0)
	await tween.finished
	set_process(true)
	state = rush_state

func decelerate_state(delta):
	velocity = velocity.move_toward(Vector2.ZERO, acceleration * delta)
	move(delta)
	if velocity == Vector2.ZERO:
		state = recenter_state

func move(delta):
	translate(velocity * delta)

func _on_hurtbox_hurt(_hitbox, damage):
	stats.health -= damage

func _on_stats_no_health():
	queue_free()

func _on_attack_timer_timeout():
	state = decelerate_state

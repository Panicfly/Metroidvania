extends Node2D

const STINGER_SCENE = preload("res://enemies/stinger.tscn")
const MISSILE_POWERUP_SCENE = preload("res://player/missile_powerup.tscn")
const ENEMY_DEATH_EFFECT_SCENE = preload("res://effects/enemy_death_effect.tscn")

@export var acceleration = 200
@export var max_speed = 600
@export var targets: Array[NodePath]

var state = rush_state: set = set_state
var state_init = true: get = get_state_init
var velocity = Vector2.ZERO

var STATE_OPTIONS = [shooting_state, shooting_state, rush_state, rush_state]
var state_options_left = []

@onready var stats = $Stats
@onready var stinger_pivot_point = $StingerPivotPoint
@onready var muzzle = $StingerPivotPoint/Muzzle
@onready var stinger_shooting_timer = $StingerShootingTimer
@onready var state_timer = $StateTimer

func set_state(value):
	state = value
	state_init = true

func get_state_init():
	#I made this getter for setting state_init to false so I dont have to set it manually everytime
	var state_was = state_init
	state_init = false
	return state_was

func _ready():
	var freed = WorldStash.retrieve_data("bee_boss", "freed")
	if freed: queue_free()

func _process(delta):
	state.call(delta)

func rush_state(delta):
	if state_init:
		state_timer.start(randf_range(4.0, 7.0))
		#When the time is finished connect to set state function and pass in decelerate state
		state_timer.timeout.connect(set_state.bind(decelerate_state), CONNECT_ONE_SHOT)
		state_init = false
	var player = MainInstances.player
	if not player is Player: return
	var direction = global_position.direction_to(player.global_position)
	velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
	move(delta)

func shooting_state(_delta):
	if state_init:
		state_timer.start(randf_range(3.0, 6.0))
		state_timer.timeout.connect(set_state.bind(recenter_state), CONNECT_ONE_SHOT)
	if stinger_shooting_timer.time_left == 0:
		stinger_pivot_point.rotation_degrees += 18
		stinger_shooting_timer.start()
		var stinger = Utils.instantiate_scene_on_level(STINGER_SCENE, muzzle.global_position)
		stinger.rotation = stinger_pivot_point.rotation
		stinger.update_velocity()

func recenter_state(_delta):
	#Error Message target_is empty if the markes are not assigned
	assert(not targets.is_empty())
	if state_init:
		#This will get one random node out of our array of targets
		var center_node = get_node(targets.pick_random())
		#A tween is a process which has only to be called once and not every process frame. It does his job and stops
		var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		#Object of Change in this case Self = Boss Node, Attribut of change, to what it should get changed to, the time for the change
		tween.tween_property(self, "global_position", center_node.global_position, 2.0)
		await tween.finished
		state_timer.start(0.5)
		await state_timer.timeout
		if state_options_left.is_empty():
			state_options_left = STATE_OPTIONS.duplicate()
			state_options_left.shuffle()
		state = state_options_left.pop_back()

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
	WorldStash.stash_data("bee_boss", "freed", true)
	Utils.instantiate_scene_on_level(MISSILE_POWERUP_SCENE, global_position)
	Utils.instantiate_scene_on_level(ENEMY_DEATH_EFFECT_SCENE, global_position)

extends CharacterBody2D

const DUST_EFFECT_SCENE = preload("res://effects/dust_effect.tscn")
const JUMP_EFFECT_SCENE = preload("res://effects/jump_effect.tscn")

#accelaration is high because its mulitplied by delta
@export var accelaration = 600
@export var max_velocity = 100
@export var friction = 500
@export var gravity = 650
@export var jump_force = 220
@export var max_fall_velocity = 280

var air_jump = false
var state = move_state

@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $Sprite2D
@onready var coyote_jump_timer = $CoyoteJumpTimer
@onready var player_blaster = $PlayerBlaster
@onready var fire_rate_timer = $FireRateTimer
@onready var drop_timer = $DropTimer
@onready var camera_2d = $Camera2D
@onready var hurtbox : = $Hurtbox
@onready var blinking_animation_player = $BlinkingAnimationPlayer

func _ready():
	PlayerStats.no_health.connect(die)

func _physics_process(delta):
	state.call(delta)

func move_state(delta):
	apply_gravity(delta)
	var input_axis = Input.get_axis("move_left", "move_right")
	if is_moving(input_axis):
		apply_accelaration(delta, input_axis)
	else:
		apply_friction(delta)
	jump_check()
	if Input.is_action_pressed("fire_bullet") and fire_rate_timer.time_left == 0:
		fire_rate_timer.start()
		player_blaster.fire_bullet()
	#Possibility to jump down through moving plattforms
	if Input.is_action_pressed("crouch") and Input.is_action_pressed("jump"):
		set_collision_mask_value(2, false)
		drop_timer.start()
	update_animations(input_axis)
	var was_on_floor = is_on_floor()
	move_and_slide()
	var just_left_edge = was_on_floor and not is_on_floor() and velocity.y >= 0
	if just_left_edge:
		coyote_jump_timer.start()

func wall_slide_state(delta):
	pass

func create_dust_effect():
	Utils.instantiate_scene_on_world(DUST_EFFECT_SCENE, global_position)

func is_moving(input_axis):
	return input_axis != 0

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y = move_toward(velocity.y, max_fall_velocity, gravity * delta)

func apply_accelaration(delta, input_axis):
		velocity.x = move_toward(velocity.x, input_axis * max_velocity, accelaration * delta)

func apply_friction(delta):
		velocity.x = move_toward(velocity.x, 0, friction * delta)

func jump_check():
	if is_on_floor():
		air_jump = true
	
	if is_on_floor() and not Input.is_action_pressed("crouch") or coyote_jump_timer.time_left > 0.0:
		if Input.is_action_just_pressed("jump"):
			jump(jump_force)
	if not is_on_floor():
		if Input.is_action_just_released("jump") and velocity.y < -jump_force / 2.0:
			velocity.y = -jump_force / 2.0
			
		#Doublejump Check
		if Input.is_action_just_pressed("jump") and air_jump:
			jump(jump_force * 0.8)
			air_jump = false

func jump(force):
	velocity.y = -force
	Utils.instantiate_scene_on_world(JUMP_EFFECT_SCENE, global_position)

func update_animations(input_axis):
	sprite_2d.scale.x = sign(get_local_mouse_position().x)
	#You need this check because if the mouse is in the origin the character despawns
	if abs(sprite_2d.scale.x) != 1:
		sprite_2d.scale.x = 1
	if is_moving(input_axis):
		animation_player.play("run")
		#The character was able to move backwards without the speed_scale change. 
		#When you face to the right and walk backwards it's -1
		animation_player.speed_scale = input_axis * sprite_2d.scale.x
	else:
		animation_player.play("idle")
	
	if not is_on_floor():
		animation_player.play("jump")

func die():
	camera_2d.reparent(get_tree().current_scene)
	queue_free()

func _on_drop_timer_timeout():
	set_collision_mask_value(2, true)

func _on_hurtbox_hurt(_hitbox, _damage):
	Events.add_screenshake.emit(3, 0.25)
	PlayerStats.health -= 1
	hurtbox.is_invincible = true
	blinking_animation_player.play("blink")
	await blinking_animation_player.animation_finished
	#await get_tree().create_timer(1.0).timeout
	hurtbox.is_invincible = false

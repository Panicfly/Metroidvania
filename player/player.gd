extends CharacterBody2D

const DUST_EFFECT_SCENE = preload("res://effects/dust_effect.tscn")

#accelaration is high because its mulitplied by delta
@export var accelaration = 600
@export var max_velocity = 100
@export var friction = 500
@export var gravity = 600
@export var jump_force = 220
@export var max_fall_velocity = 200

@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $Sprite2D
@onready var coyote_jump_timer = $CoyoteJumpTimer
@onready var player_blaster = $PlayerBlaster

func _physics_process(delta):
	apply_gravity(delta)
	var input_axis = Input.get_axis("move_left", "move_right")
	if is_moving(input_axis):
		apply_accelaration(delta, input_axis)
	else:
		apply_friction(delta)
	jump_check()
	if Input.is_action_just_pressed("fire_bullet"):
		player_blaster.fire_bullet()
	update_animations(input_axis)
	var was_on_floor = is_on_floor()
	move_and_slide()
	var just_left_edge = was_on_floor and not is_on_floor() and velocity.y >= 0
	if just_left_edge:
		coyote_jump_timer.start()

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
	if is_on_floor() or coyote_jump_timer.time_left > 0.0:
		if Input.is_action_just_pressed("jump"):
			velocity.y = -jump_force
	if not is_on_floor():
		if Input.is_action_just_released("jump") and velocity.y < -jump_force / 2:
			velocity.y = -jump_force / 2

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
	

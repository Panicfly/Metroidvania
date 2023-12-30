extends CharacterBody2D

@export var acceleration = 100
@export var max_speed = 40
@export var player_path : NodePath

@onready var animated_sprite_2d = $AnimatedSprite2D

func _physics_process(delta):
	if player_path is NodePath:
		var player = get_node(player_path)
		if player is CharacterBody2D:
			move_toward_target(player.global_position)
	move_and_slide()

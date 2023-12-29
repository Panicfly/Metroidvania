extends CharacterBody2D

@export var acceleration = 100
@export var max_speed = 40

@onready var animated_sprite_2d = $AnimatedSprite2D

func _physics_process(delta):
	
	move_and_slide()

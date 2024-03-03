extends Camera2D

var shake = 0

@onready var timer = $Timer
@onready var camera_2d = $"."

func _ready():
	Events.add_screenshake.connect(start_screenshake)
	Events.camera_limits_changed.connect(update_camera_limits)

func _process(_delta):
	offset.x = randf_range(-shake, shake)
	offset.y = randf_range(-shake, shake)

func update_camera_limits(left, right, top, bottom):
	limit_left = left
	limit_right = right
	limit_top = top
	limit_bottom = bottom

func start_screenshake(amount, duration):
	shake = amount
	timer.start(duration)

func _on_timer_timeout():
	shake = 0

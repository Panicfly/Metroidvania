extends Level

@onready var bricks = $Bricks
@onready var room_enter_trigger = $RoomEnterTrigger
@onready var brick_4 = $Bricks/Brick4
@onready var brick_5 = $Bricks/Brick5

func _ready():
	bricks.hide()
	await Music.fade_music(2.0)
	Music.play_music(Music.theme, 68.0)

func _on_room_enter_trigger_trigger_room_entered():
	var boss_freed = WorldStash.retrieve_data("bee_boss", "freed")
	if not boss_freed:
		bricks.show()
		room_enter_trigger.trigger_active = false

func _on_boss_enemy_tree_exited():
	if is_instance_valid(brick_4):
		brick_4.queue_free()
	if is_instance_valid(brick_5):
		brick_5.queue_free()
	return

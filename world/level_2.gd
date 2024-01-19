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
	brick_4.queue_free()
	brick_5.queue_free()

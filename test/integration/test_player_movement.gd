extends GutTest

var level = load("res://test/ressource/test_flat_level.tscn")

var _level = null
var _player = null
var _sender = InputSender.new(Input)

func before_each():
	_level = add_child_autofree(level.instantiate())
	_player = _level.get_node("Player")
	await get_tree().create_timer(1.0).timeout

func after_each():
	#Inputs don't go from one test to another
	_sender.release_all()
	#Clears sender state
	_sender.clear()

func test_verify_setup():
	assert_not_null(_player, "player exists")
	assert_true(_player.is_on_floor(), "Player is on the floor")

func test_player_jump():
	_player.jump(220, true)
	await get_tree().create_timer(.5).timeout
	assert_true(not _player.is_on_floor(), "Player jumped sucessfully")

func test_player_walks_left():
	_sender.action_down("move_left").hold_for(2)
	await(_sender.idle)
	assert_true(_player.position.x < 0)

func test_player_takes_damage():
	PlayerStats.health = 4
	_player._on_hurtbox_hurt(null, 1)
	assert_eq(PlayerStats.health, 3, "Health should be 3")

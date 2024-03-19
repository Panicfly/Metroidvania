extends StaticBody2D

@onready var animation_player = $AnimationPlayer

func _on_area_2d_body_entered(player):
	if not player is Player: return
	PlayerStats.refill_stats()
	Sound.play(Sound.powerup, 0.6, -10)
	SaveHandler.save_game()
	animation_player.play("saving")

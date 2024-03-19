extends ColorRect

func _ready():
	PlayerStats.reset_stats()

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://world.tscn")
	Sound.play(Sound.click, 1.0, -15.0)

func _on_load_button_pressed():
	Sound.play(Sound.click, 1.0, -15.0)
	SaveHandler.is_loading = true
	get_tree().change_scene_to_file("res://world.tscn")

func _on_quit_button_pressed():
	get_tree().quit()

extends ColorRect

func _on_load_pressed():
	Sound.play(Sound.click, 1.0, -15.0)
	SaveHandler.is_loading = true
	get_tree().change_scene_to_file("res://world.tscn")

func _on_quit_pressed():
	get_tree().quit()

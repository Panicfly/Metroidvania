extends ColorRect

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://world.tscn")
	Sound.play(Sound.click, 1.0, -15.0)

func _on_load_button_pressed():
	Sound.play(Sound.click, 1.0, -15.0)
	print("Load Save Game")
	pass # Replace with function body.

func _on_quit_button_pressed():
	get_tree().quit()

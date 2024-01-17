extends ColorRect

var paused = false : 
	set(value):
		paused = value
		get_tree().paused = paused
		visible = paused
		if paused:
			Sound.play(Sound.pause, 1.0, -15.0)
		else:
			Sound.play(Sound.unpause, 1.0, -15.0)

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		paused = !paused

func _on_resume_pressed():
	paused = false
	Sound.play(Sound.click, 1.0, -10.0)

func _on_quit_pressed():
	get_tree().quit()

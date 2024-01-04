extends ColorRect

var paused = false : 
	set(value):
		paused = value
		get_tree().paused = paused
		visible = paused

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		paused = !paused

func _on_resume_pressed():
	paused = false

func _on_quit_pressed():
	get_tree().quit()

extends CanvasLayer

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		toggle()

func toggle():
	var new = not get_tree().paused
	get_tree().paused = new
	for child in get_children():
		child.visible = new

func _on_Quit_pressed():
	get_tree().quit()

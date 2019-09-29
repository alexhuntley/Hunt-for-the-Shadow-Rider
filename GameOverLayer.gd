extends CanvasLayer


func _on_Quit_pressed():
	get_tree().quit()


func _on_Restart_pressed():
	get_tree().paused = false
	get_tree().change_scene(get_tree().get_current_scene().filename)

func show():
	get_tree().paused = true
	for child in get_children():
		if not child is AudioStreamPlayer:
			child.show()
	$GameOverSound.play()
extends Control


func _on_Button_pressed():
	$SelectBeep.play()
	yield($SelectBeep, "finished")
	get_tree().change_scene("Intro.tscn")

func _on_Help_pressed():
	$Tween.interpolate_property(self, "rect_position", rect_position, Vector2(-640, 0), 0.4, Tween.TRANS_EXPO, Tween.EASE_OUT)
	$Tween.start()
	$SelectBeep.play()

func _on_Credits_pressed():
	$Tween.interpolate_property(self, "rect_position", rect_position, Vector2(0, 360), 0.4, Tween.TRANS_EXPO, Tween.EASE_OUT)
	$Tween.start()
	$SelectBeep.play()

func _on_Return_pressed():
	$Tween.interpolate_property(self, "rect_position", rect_position, Vector2(0, 0), 0.4, Tween.TRANS_EXPO, Tween.EASE_OUT)
	$Tween.start()
	$SelectBeep.play()

func _on_Quit_pressed():
	$SelectBeep.play()
	yield($SelectBeep, "finished")
	get_tree().quit()


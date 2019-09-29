extends AnimatedSprite

func _on_Explosion_animation_finished():
	hide()

func _on_AudioStreamPlayer2D_finished():
	queue_free()
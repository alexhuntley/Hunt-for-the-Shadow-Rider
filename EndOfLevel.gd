extends Node2D

export (PackedScene) var next_level


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		$AnimationPlayer.play("FlyOff")


func _on_AnimationPlayer_animation_finished(anim_name):
	get_tree().change_scene_to(next_level)

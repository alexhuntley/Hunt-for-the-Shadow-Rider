extends Node

signal player_on_ladder(yes)

func _on_child_body_entered(body):
	if body == get_node("../Player"):
		emit_signal("player_on_ladder", true)

func _on_child_body_exited(body):
	if body == get_node("../Player"):
		emit_signal("player_on_ladder", false)
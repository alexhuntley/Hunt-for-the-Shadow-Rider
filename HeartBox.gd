extends HBoxContainer

var hearts = 0 setget set_hearts
var full_heart = load("res://HeartFull.tscn")

func set_hearts(n):
	for heart in get_children():
		heart.queue_free()
	for i in range(n):
		var new_heart = full_heart.instance()
		add_child(new_heart)
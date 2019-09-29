extends "res://Shot.gd"

func hittable(collider):
	return collider.name == "Player"
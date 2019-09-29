extends PathFollow2D

onready var old_position = global_position
onready var old_left = $Drone.left

func _physics_process(delta):
	var delta_x = global_position.x - old_position.x
	if abs(delta_x) > 1:
		var new_left = delta_x < 0
		if new_left != old_left:
			$Drone.turn(new_left)
		old_left = new_left
	old_position = global_position
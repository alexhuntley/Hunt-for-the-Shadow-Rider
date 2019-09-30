extends Path2D

func _ready():
	$DroneController/Drone/AnimationPlayer.stop()
	$DroneController.unit_offset = randf()

func _physics_process(delta):
	$DroneController.offset += delta * 150
extends Path2D

func _ready():
	$DroneController/Drone/AnimationPlayer.stop()

func _physics_process(delta):
	$DroneController.offset += delta * 150
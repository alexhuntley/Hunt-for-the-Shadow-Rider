extends KinematicBody2D

export var rotates = false
var rotating = false
export (bool) var on = true

enum Direction {LEFT, RIGHT}
export (Direction) var direction = Direction.LEFT

var shot = load("res://EnemyShot.tscn")
var explosion = load("res://Explosion.tscn")

const pitch_increase = 0.6
var started = false

func start():
	$Hum.play()
	$ShotDelay.start()
	$TurnOn.play()
	started = true

func _process(delta):
	if direction == Direction.LEFT:
		$AnimatedSprite.play("Left")
		$Spawns.scale.x = 1
	else:
		$AnimatedSprite.play("Right")
		$Spawns.scale.x = -1
	if not started:
		return
	if rotating:
		return
	if rotates:
		var to_player: Vector2 = get_tree().get_current_scene().get_node("Player").global_position - global_position
		var new_direction = Direction.LEFT if to_player.x < 0 else Direction.RIGHT
		if new_direction != direction:
			rotating = true
			$ShotDelay.stop()
			if new_direction == Direction.LEFT:
				$AnimatedSprite.play("RightToLeft")
			else:
				$AnimatedSprite.play("LeftToRight")
			direction = new_direction
			$Hum.pitch_scale = 1.05
			return
	var elapsed = ($ShotDelay.wait_time - $ShotDelay.time_left)/$ShotDelay.wait_time
	$Hum.pitch_scale = 0.8 + pitch_increase*pow(elapsed, 1)
	$Hum.volume_db = -40 + 25*elapsed

func _on_ShotDelay_timeout():
	var bullet = shot.instance()
	if direction == Direction.LEFT:
		bullet.velocity.x *= -1
	bullet.position = $Spawns/ShotSpawn.global_position
	get_tree().get_current_scene().add_child(bullet)
	$ShotSound.play()

func hit(pos):
	var expl = explosion.instance()
	expl.position = $Spawns.global_position
	get_tree().get_current_scene().add_child(expl)
	queue_free()

func _on_AnimatedSprite_animation_finished():
	if rotating:
		$ShotDelay.start()
		rotating = false
		$Hum.pitch_scale = 0.8


func _on_DetectionArea_body_entered(body):
	if body.name == "Player" and on and not started:
		start()

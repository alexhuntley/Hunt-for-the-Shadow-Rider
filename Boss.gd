extends KinematicBody2D

var shot = load("res://EnemyShot.tscn")
var explosion = load("res://Explosion.tscn")
var drone = load("res://Drone.tscn")

var phase = -1
var health = 5

func _ready():
	randomize()
	yield(get_tree().create_timer(1.0), "timeout")
	$PhaseTimer.start()
	_on_PhaseTimer_timeout()

var t = 0.0
const omega = 2*PI*0.5
var velocity = 0.0
func _process(delta):
	if not dead:
		t += delta
		if t >= 2*PI/omega:
			t -= 2*PI/omega
		velocity = 100*sin(omega*t)
	else:
		velocity += 800*delta
	move_and_slide(Vector2(0,velocity))

func fire():
	var bullet = shot.instance()
	bullet.velocity.x *= -1
	bullet.position = $ShotSpawn.global_position
	get_tree().get_current_scene().add_child(bullet)
	$ShotSound.play()

func spawn_drone():
	var pos = rand_pos_local(200) + global_position
	var new_drone = drone.instance()
	new_drone.global_position = pos
	new_drone.hunts = true
	new_drone.hunting = true
	get_tree().get_current_scene().add_child(new_drone)

func _on_PhaseTimer_timeout():
	phase = (phase + 1) % 2
	match phase:
		# shooting
		0:
			$ShotTimer.start()
			$DroneTimer.stop()
		# spawning drones
		1:
			$ShotTimer.stop()
			$DroneTimer.start()

func hit(pos):
	health -= 1
	print(health)
	if health <= 0:
		die()

func explode():
	var expl = explosion.instance()
	expl.position = global_position + rand_pos_local(100)
	get_tree().get_current_scene().add_child(expl)

func rand_pos_local(max_radius):
	return Vector2(randf()*max_radius, 0).rotated(randf()*2*PI)

var dead = false
func die():
	$ShotTimer.stop()
	$DroneTimer.stop()
	$PhaseTimer.stop()
	dead = true
	$Tween.interpolate_property($Sprite, "modulate", Color(1,1,1,1), Color(0,0,0,1), 0.4,
		Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.start()
	for i in range(30):
		explode()
		yield(get_tree().create_timer(0.1), "timeout")
	yield(get_tree().create_timer(2.0), "timeout")
	get_tree().change_scene("res://Outro.tscn")
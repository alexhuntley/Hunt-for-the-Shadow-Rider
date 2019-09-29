extends KinematicBody2D

const ACCEL = 4000
const GRAVITY = 800
const JUMP_SPEED = 450
const CLIMB_SPEED = 100

var velocity = Vector2()
var jumping = false
var shooting = true
var left = false
var on_ladder = false setget set_on_ladder

var shot = load("res://Shot.tscn")

var new_anim

signal lives(n)
var lives = 0 setget set_lives
var flinch_direction: float = 0

signal die

func _physics_process(delta):
	if $HurtTimer.time_left:
		$AnimatedSprite.animation = "Hurt"
		velocity.x = $HurtTimer.time_left * 400 * flinch_direction
		apply_gravity(delta)
		velocity = move_and_slide(velocity, Vector2.UP)
		return
	shooting = Input.is_action_pressed("shoot")
	if jumping and is_on_floor():
		jumping = false
	if Input.is_action_pressed("down") and not on_ladder and not jumping:
		new_anim = "Crouch"
		if shooting:
			fire($Spawns/CrouchShootSpawn)
	elif Input.is_action_pressed("run_left"):
		run(true, delta)
	elif Input.is_action_pressed("run_right"):
		run(false, delta)
	elif not jumping:
		new_anim = "Shoot" if shooting else "Idle"
		if shooting:
			fire($Spawns/ShootSpawn)
	apply_resistance(delta)
	apply_gravity(delta)
	if Input.is_action_pressed("up") and is_on_floor():
		velocity.y = -JUMP_SPEED
		jumping = true
	if jumping:
		new_anim = "Jump"
		if shooting:
			new_anim = "JumpShoot"
			fire($Spawns/JumpShootSpawn)
	if on_ladder:
		velocity.y = 0
		new_anim = "Climb"
		$AnimatedSprite.playing = true
		if Input.is_action_pressed("up"):
			velocity.y = -CLIMB_SPEED
		elif Input.is_action_pressed("down"):
			velocity.y = CLIMB_SPEED
		else:
			$AnimatedSprite.playing = false
	velocity = move_and_slide(velocity, Vector2.UP)
	for i in range(get_slide_count()):
		var collision = get_slide_collision(i)
		if collision.collider.is_in_group("Enemies"):
			hit(collision.collider.global_position)
	if global_position.y > 1200:
		hit(global_position)
	if not new_anim == $AnimatedSprite.animation and not new_anim == "":
		$AnimatedSprite.animation = new_anim
		$AnimatedSprite.playing = true

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta
func apply_resistance(delta):
	# Air resistance
	velocity.x -= 0.002*velocity.x*abs(velocity.x) * delta
	# Friction
	if is_on_floor() or on_ladder:
		velocity.x = lerp(velocity.x, 0, 0.12)

func fire(spawn: Node2D):
	if $ShotDelay.time_left:
		return
	var bullet = shot.instance()
	get_tree().get_current_scene().add_child(bullet)
	bullet.position = spawn.global_position
	bullet.velocity.x *= -1 if left else 1
	bullet.velocity.x += velocity.x
	$ShotDelay.start()
	$ShotPlayer.play()
	
func run(left: bool, delta: float):
	self.left = left
	var air_multiplier = 0.1 if not (is_on_floor() or on_ladder) else 1.0
	velocity.x -= ACCEL*delta*air_multiplier*(1 if left else -1)
	$AnimatedSprite.flip_h = left
	$Spawns.scale.x = -1 if left else 1
	if not jumping:
		new_anim = "RunShoot" if shooting else "Run"
		if shooting:
			fire($Spawns/RunShootSpawn)

func set_on_ladder(yes):
	on_ladder = yes

func set_lives(n):
	lives = n
	emit_signal("lives", lives)

func hit(bullet_pos):
	if $HurtTimer.time_left:
		return
	flinch_direction = sign(global_position.x - bullet_pos.x)
	set_lives(lives - 1)
	if lives < 0:
		emit_signal("die")
	$HurtTimer.start()
	$HurtPlayer.play()

func _ready():
	set_lives(3)
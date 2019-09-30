extends KinematicBody2D

var explosion = load("res://Explosion.tscn")

export (bool) var hunts
var hunting = false
onready var player = get_tree().get_current_scene().get_node("Player")
var to_player = Vector2()
var velocity = Vector2()
export var left = true
var turning = false

func _ready():
	$AnimationPlayer.play("Hover")
	if hunts:
		$AnimatedSprite.animation = "Observe"

func hit(pos):
	var expl = explosion.instance()
	expl.position = global_position
	get_tree().get_current_scene().add_child(expl)
	# free path and controller if they exist
	var grandparent = get_parent().get_parent()
	if grandparent is Path2D:
		grandparent.queue_free()
	queue_free()

func _process(delta):
	if hunts:
		if not hunting and $DetectionArea.overlaps_body(player):
			hunting = true
			$Hunting.play()
			$AnimatedSprite.animation = "Forward"
			$AnimationPlayer.stop()
	if $AnimatedSprite.animation == "Forward":
		$AnimatedSprite.flip_h = not left
	if hunting:
		var new_left = to_player.x < 0
		if new_left != left:
			turn(new_left)

func turn(new_left: bool):
	turning = true
	left = new_left
	$AnimatedSprite.flip_h = false
	$AnimatedSprite.animation = "RightToLeft" if new_left else "LeftToRight"

func _physics_process(delta):
	if player:
		to_player = player.global_position - global_position
	if hunting:
		velocity += 4*to_player*delta
		velocity = lerp(velocity, Vector2.ZERO, 0.02)
		velocity = move_and_slide(velocity)
		for i in range(get_slide_count()):
			var collision = get_slide_collision(i)
			if collision.collider.name == "Player":
				collision.collider.hit(global_position)

func _on_AnimatedSprite_animation_finished():
	if turning:
		turning = false
		$AnimatedSprite.animation = "Forward"
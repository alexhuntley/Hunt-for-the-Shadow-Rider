extends KinematicBody2D

const LIFETIME = 2.0

var velocity = Vector2(600, 0)

var shot_hit = load("res://ShotHit.tscn")

func _ready():
	$Timer.start(LIFETIME)
	$ScaleTween.interpolate_property($AnimatedSprite, "scale", $AnimatedSprite.scale, Vector2.ZERO,
		LIFETIME, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$ScaleTween.start()
	$OpacityTween.interpolate_property($AnimatedSprite, "self_modulate", Color.white, Color(1,1,1,0),
		LIFETIME, Tween.TRANS_CUBIC, Tween.EASE_OUT)

func _physics_process(delta):
	var collision = move_and_collide(velocity*delta)
	if collision:
		if hittable(collision.collider):
			collision.collider.hit(global_position)
		var hit = shot_hit.instance()
		hit.global_position = global_position
		hit.modulate = $AnimatedSprite.modulate
		get_tree().get_current_scene().add_child(hit)
		queue_free()

func _process(delta):
	if velocity.x < 0:
		$AnimatedSprite.flip_h = true

func hittable(collider):
	return collider.is_in_group("Enemies")


func _on_Timer_timeout():
	queue_free()

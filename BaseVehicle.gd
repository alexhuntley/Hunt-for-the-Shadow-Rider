extends Sprite

export var MAX_SPEED = 600
export var MIN_SPEED = 300
var velocity = rand_range(MIN_SPEED, MAX_SPEED)
var left

func _ready():
	randomize()
	left = randf() > 0.5
	if left:
		velocity *= -1
		global_position.x = get_viewport_rect().size.x + texture.get_size().x
	else:
		flip_h = true
		global_position.x = - texture.get_size().x
	global_position.y = rand_range(0, get_viewport_rect().size.y)

func _process(delta):
	translate(Vector2(velocity, 0)*delta)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

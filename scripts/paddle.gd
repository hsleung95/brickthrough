extends Area2D

var speed = 300.0
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size

func _process(delta):
	var velocity = calVelocity()
	position += velocity * delta
	position = position.clamp(screen_size * 0.01, screen_size * 0.85)

func calVelocity():
	var velocity = Vector2.ZERO
	if (Input.is_action_pressed("move_left")):
		velocity.x += -1
	elif (Input.is_action_pressed("move_right")):
		velocity.x += 1
	if (velocity.length() > 0):
		velocity = velocity.normalized() * speed
	return velocity

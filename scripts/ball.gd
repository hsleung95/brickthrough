extends CharacterBody2D

@onready var camera := $"../Camera2D"

const INIT_BALL_SPEED_X = 200
const INIT_BALL_SPEED_Y = 250
var BALL_RADIUS := 9.0
var ballSpeed = 1
var ballSize = 1

signal ball_removed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	velocity = Vector2(INIT_BALL_SPEED_X * ballSpeed, INIT_BALL_SPEED_Y * ballSpeed)
	scale = Vector2(ballSize, ballSize)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var collision = move_and_collide(velocity * delta)

	if collision:
		# Reflect velocity around the collision normal
		# You can scale the result to add energy loss (e.g., * 0.8)
		$HitSound.play()
		velocity = velocity.bounce(collision.get_normal())
		var collider = collision.get_collider()
		if (collider.is_in_group("Hittable")):
			collider.call("on_hit", collision.get_position())
	# 2) Camera-rect "walls" (after movement)
	var cam_rect: Rect2 = camera.get_world_rect()

	# Left wall
	if global_position.x - BALL_RADIUS < cam_rect.position.x:
		$HitSound.play()
		velocity.x = -velocity.x

	# Right wall
	var right = cam_rect.position.x + cam_rect.size.x
	if global_position.x + BALL_RADIUS > right:
		$HitSound.play()
		velocity.x = -velocity.x

	# Top wall
	if global_position.y - BALL_RADIUS < cam_rect.position.y + 48 / camera.zoom.x:
		$HitSound.play()
		velocity.y = -velocity.y

	# Bottom: lose ball
	var bottom = cam_rect.position.y + cam_rect.size.y
	if global_position.y - BALL_RADIUS > bottom:
		ball_removed.emit()
		queue_free()

func reset() -> void:
	ballSize = 1
	ballSpeed = 1
	

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	ball_removed.emit()
	queue_free()

func updateSpeed(newSpeed: float) -> void:
	var currentDirectionX = sign(velocity.x)
	var currentDirectionY = sign(velocity.y)
	ballSpeed = abs(newSpeed)
	velocity = Vector2(currentDirectionX * velocity.x * ballSpeed, currentDirectionY * velocity.y * ballSpeed)

func updateSize(newSize: float) -> void:
	var newScale = max(newSize, 0.05)
	ballSize = newScale
	scale = Vector2(ballSize, ballSize)

extends RigidBody2D

var velocityY = -200
var velocityX = 200

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2(velocityX, velocityY)
	var collision = move_and_collide(velocity * delta)

	if collision:
		# Reflect velocity around the collision normal
		# You can scale the result to add energy loss (e.g., * 0.8)
		velocity = velocity.bounce(collision.get_normal())
		velocityX = velocity.x
		velocityY = velocity.y
		#if (velocity.y > 0):
			#velocityY = velocity.y + 100
		#else:
			#velocityY = velocity.y - 100
		#if (velocity.x > 0):
			#velocityX = velocity.x + 100
		#else:
			#velocityX = velocity.x - 100


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

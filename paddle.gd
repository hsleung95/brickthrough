extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	var direction = calDirection()
	velocity.x = direction * SPEED

	move_and_slide()

func calDirection():
	if (Input.is_action_pressed("move_left")):
		return -1
	elif (Input.is_action_pressed("move_right")):
		return 1
	else:
		return 0

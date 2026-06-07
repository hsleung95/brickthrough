extends RigidBody2D

signal powerUpTriggered
var powerUpType;

const ICON_BALL_NUM = preload("res://icons/ball_num.png")
const ICON_BALL_SIZE_DECREASE = preload("res://icons/ball_size_decrease.png")
const ICON_BALL_SIZE_INCREASE = preload("res://icons/ball_size_increase.png")
const ICON_BALL_SPEED_INCREASE = preload("res://icons/ball_speed_increase.png")
const ICON_PADDLE_SIZE_DECREASE = preload("res://icons/paddle_size_decrease.png")
const ICON_PADDLE_SIZE_INCREASE = preload("res://icons/paddle_size_increase.png")
const ICON_PADDLE_SPEED_INCREASE = preload("res://icons/paddle_speed_increase.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	powerUpType = randi_range(-2,4)
	if (powerUpType == -2):
		$Label.text = "PL"
		$icon.texture = ICON_PADDLE_SIZE_DECREASE
	elif (powerUpType == -1):
		$icon.texture = ICON_BALL_SIZE_DECREASE
	elif (powerUpType == 0):
		$icon.texture = ICON_PADDLE_SPEED_INCREASE
	elif (powerUpType == 1):
		$icon.texture = ICON_PADDLE_SIZE_INCREASE
	elif (powerUpType == 2):
		$icon.texture = ICON_BALL_NUM
	elif (powerUpType == 3):
		$icon.texture = ICON_BALL_SPEED_INCREASE
	else:
		$icon.texture = ICON_BALL_SIZE_INCREASE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var collide = move_and_collide(Vector2(0,2))
	if (collide):
		powerUpTriggered.emit(powerUpType)
		queue_free()

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()

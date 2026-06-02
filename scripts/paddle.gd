extends AnimatableBody2D

signal ball_hit

@onready var camera := $"../Camera2D"
@export var speed: float = 500.0
@export var left_limit: float = 50.0
@export var right_limit: float = 670.0

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	var dir := Input.get_axis("move_left", "move_right")
	var cam_rect = camera.get_world_rect()
	var left_limit_zoomed = max(left_limit , cam_rect.position.x + left_limit)
	var right_limit_zoomed = min(right_limit, right_limit - cam_rect.position.x)
	var new_x := clampf(global_position.x + dir * speed * delta, left_limit_zoomed, right_limit_zoomed)
	global_position.x = new_x

func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body.is_in_group("Balls")):
		ball_hit.emit()
	elif (body.is_in_group("PowerUps")):
		print("power up hit")
		body.getPowerUp()

func reset() -> void:
	scale.x = 1
	speed = 500

func update_size(newSize: float) -> void:
	var newScaleX = scale.x * newSize
	scale.x = max(0.25, newScaleX)

func increase_speed() -> void:
	speed *= 1.05

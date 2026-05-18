extends AnimatableBody2D

signal ball_hit

@export var speed: float = 500.0
@export var left_limit: float = 50.0
@export var right_limit: float = 670.0

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	var dir := Input.get_axis("move_left", "move_right")
	var new_x := clampf(global_position.x + dir * speed * delta, left_limit, right_limit)
	global_position.x = new_x

func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body.is_in_group("Balls")):
		ball_hit.emit()

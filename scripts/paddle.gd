extends RigidBody2D


@export var move_speed: float = 600.0
@export var left_limit: float = 50.0
@export var right_limit: float = 670.0

func _ready() -> void:
	lock_rotation = true
	gravity_scale = 0.0
	linear_damp = 0.0
	angular_damp = 10.0

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var input_dir := Input.get_axis("move_left", "move_right")

	# Horizontal only
	var v := state.linear_velocity
	v.x = input_dir * move_speed
	v.y = 0.0
	state.linear_velocity = v

	# Keep paddle inside arena
	var t := state.transform
	t.origin.x = clampf(t.origin.x, left_limit, right_limit)
	state.transform = t

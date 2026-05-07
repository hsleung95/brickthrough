extends RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var collision = move_and_collide(Vector2(0,0.1))
	if (collision):
		queue_free()

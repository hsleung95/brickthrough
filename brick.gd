extends RigidBody2D

signal block_destroyed
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	
	var collide = move_and_collide(Vector2(0,0.5))
	
func on_hit() -> void:
	destroy_block()	

func destroy_block():
	block_destroyed.emit()
	queue_free()

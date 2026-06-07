extends RigidBody2D

signal block_destroyed
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:	
	move_and_collide(Vector2(0,0.125))
	
func on_hit(_position: Vector2) -> void:
	destroy_block(_position)	

func destroy_block(destroyedPosition: Vector2) -> void:
	block_destroyed.emit(destroyedPosition)
	queue_free()

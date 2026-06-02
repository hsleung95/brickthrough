extends Camera2D

func get_world_rect() -> Rect2:
	var viewport_size = get_viewport_rect().size / zoom
	# visible size in world units depends on zoom
	var half_size = viewport_size * 0.5
	var center = global_position
	return Rect2(center - half_size, half_size * 2.0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

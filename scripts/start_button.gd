extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(_event: InputEvent) -> void:
	if (Input.is_anything_pressed()):
		start()

func start() -> void:
	print("start")
	get_tree().change_scene_to_file("res://main.tscn")

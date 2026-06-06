extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$UI/MaxScore.text = "Max score: " + str(Global.max_score)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

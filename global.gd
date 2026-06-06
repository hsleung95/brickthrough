extends Node

var max_score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_score = 0

func new_max_score(new_score: int) -> void:
	if (new_score > max_score):
		max_score = new_score

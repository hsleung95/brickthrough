extends Node

@export var ball_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawnBall()
	#$Paddle.ball_hit.connect(spawnBall)
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

func spawnBall() -> void:
	var ball = ball_scene.instantiate()
	ball.position = Vector2(360, 200)
	add_child(ball)

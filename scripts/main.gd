extends Node

@export var ball_scene: PackedScene
@export var brick_scene: PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawnBall()
	#$Paddle.ball_hit.connect(spawnBall)
	spawnBricks()
	score = 0
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

func spawnBall() -> void:
	var ball = ball_scene.instantiate()
	ball.position = Vector2(360, 200)
	add_child(ball)

func spawnBricks() -> void:
	for i in range(6):
		var brick = brick_scene.instantiate()
		brick.set("name", "brick" + str(i))
		brick.position = Vector2(100 + 100 * i, 150)
		brick.block_destroyed.connect(increaseScore)
		brick.add_to_group("Hittable")
		add_child(brick)

func increaseScore() -> void:
	score = score + 1
	$Score.text = str(score)

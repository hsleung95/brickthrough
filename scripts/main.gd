extends Node

@export var ball_scene: PackedScene
@export var brick_scene: PackedScene
var score
var increaseSpeedPeriod = 30
var ball_count = 0
var is_game_over = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	startGame()
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

func spawnBall() -> void:
	var ball = ball_scene.instantiate()
	ball.position = Vector2(360, 200)
	ball.ball_removed.connect(check_balls)
	ball_count += 1
	add_child(ball)

func spawnBricks() -> void:
	for i in range(6):
		var brick = brick_scene.instantiate()
		brick.set("name", "brick" + str(i))
		brick.position = Vector2(100 + 100 * i, 10)
		brick.block_destroyed.connect(increaseScore)
		brick.add_to_group("Hittable")
		add_child(brick)

func updateScore(newScore: int) -> void:
	score = newScore
	$Score.text = str(score)

func increaseScore() -> void:
	updateScore(score + 1)

func startGame() -> void:
	ball_count = 0
	
	updateScore(0)
	spawnBall()
	spawnBricks()
	$GameTimer.start()
	$BrickTimer.start()
	is_game_over = false

func _on_brick_timer_timeout() -> void:
	spawnBricks()

func _on_game_timer_timeout() -> void:
	var time_passed = Time.get_ticks_msec() / 1000
	if(time_passed % increaseSpeedPeriod == 0):
		$BrickTimer.wait_time = $BrickTimer.wait_time - 0.5

func check_balls() -> void:
	print("ball removed")
	ball_count = ball_count - 1
	if (ball_count == 0):
		endGame()
	else:
		print("ball count: " + str(ball_count))

func endGame() -> void:
	$BrickTimer.stop()
	$GameTimer.stop()
	$Score.text = "Game Over"
	score = 0
	is_game_over = true
	get_tree().call_group("Bricks", "queue_free")
	get_tree().call_group("Balls", "queue_free")

func _on_dead_zone_area_entered(area: Area2D) -> void:
	endGame()
	
func _input(event: InputEvent) -> void:
	if (is_game_over && Input.is_action_just_pressed("new_game")):
		startGame()

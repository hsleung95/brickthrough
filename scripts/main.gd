extends Node

@export var ball_scene: PackedScene
@export var brick_scene: PackedScene
var score
var increaseSpeedPeriod = 10
var zoom_out_rate = 0.00025
var ball_count = 0
var is_game_over = false
var block_num
var timePassed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	startGame()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if ($Camera2D.zoom > Vector2(1.0, 1.0)):
		$Camera2D.zoom -= Vector2(zoom_out_rate, zoom_out_rate)
		$Paddle.scale.x *= (1-zoom_out_rate)

func spawnBall() -> void:
	var ball = ball_scene.instantiate()
	ball.position = Vector2(360, 200)
	ball.ball_removed.connect(remove_ball)
	updateBallNumber(ball_count+1)
	add_child(ball)

func spawnBricks() -> void:
	for i in range(block_num):
		var brick = brick_scene.instantiate()
		brick.set("name", "brick" + str(i))
		brick.position = Vector2(100 + 100 * i, 10)
		brick.block_destroyed.connect(increaseScore)
		brick.add_to_group("Hittable")
		add_child(brick)

func increaseScore() -> void:
	updateScore(score + 1)

func startGame() -> void:
	timePassed = 0
	block_num = 6
	updateBallNumber(0)
	updateScore(0)
	spawnBall()
	spawnBricks()
	$GameTimer.start()
	$BrickTimer.start()
	is_game_over = false

func _on_brick_timer_timeout() -> void:
	spawnBricks()

func _on_game_timer_timeout() -> void:
	if (!is_game_over):
		timePassed += 1
		updateTimeLived(timePassed)

		if(timePassed % increaseSpeedPeriod == 0):
			var newWaitTime = $BrickTimer.wait_time - 0.5
			$BrickTimer.wait_time = max(newWaitTime, 0.5)

func remove_ball() -> void:
	updateBallNumber(ball_count - 1)
	if (ball_count == 0):
		#endGame()
		pass

func endGame() -> void:
	$BrickTimer.stop()
	$GameTimer.stop()
	$GUI/Score.text = "Game Over\nPress space to restart"
	is_game_over = true
	get_tree().call_group("Bricks", "queue_free")
	get_tree().call_group("Balls", "queue_free")

func _on_dead_zone_area_entered(_area: Area2D) -> void:
	endGame()
	
func _input(_event: InputEvent) -> void:
	if (is_game_over && Input.is_action_just_pressed("new_game")):
		startGame()

func updateScore(newScore: int) -> void:
	score = newScore
	$GUI/Score.text = str(score)

func updateTimeLived(timeLivedSec: float) -> void:
	var hour = floori(timeLivedSec / 3600)
	if (hour > 0):
		hour = str(hour) + ":"
	else:
		hour = ""
	var minute = floori(timeLivedSec / 60.0) % 60
	var padMin = ""
	if (minute < 10):
		padMin = "0"
	var sec = floori(timeLivedSec) % 60
	var padSec = ""
	if (sec < 10):
		padSec = "0"
	$GUI/TimeLived.text = str(hour) + padMin + str(minute) + ":" + padSec + str(sec)

func updateBallNumber(newBallCount: int) -> void:
	ball_count = newBallCount
	$GUI/BallNumber.text = "Balls: " + str(newBallCount)

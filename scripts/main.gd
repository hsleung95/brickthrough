extends Node

@export var ball_scene: PackedScene
@export var brick_scene: PackedScene
@export var power_up_scene: PackedScene
var score
var increaseSpeedPeriod = 10
var zoom_out_rate = 0.0000625
var power_up_prob = 1
var ball_count = 0
var is_game_over = false
var block_num
var timePassed
var newBallSize
var newBallSpeed
var lastBall

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	startGame()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if ($Camera2D.zoom > Vector2(1.0, 1.0)):
		$Camera2D.zoom -= Vector2(zoom_out_rate, zoom_out_rate)
		$Paddle.scale.x *= (1-zoom_out_rate)

func _on_brick_timer_timeout() -> void:
	spawnBricks()

func _on_game_timer_timeout() -> void:
	if (!is_game_over):
		timePassed += 1
		updateTimeLived(timePassed)

		if(timePassed % increaseSpeedPeriod == 0):
			var newWaitTime = $BrickTimer.wait_time - 0.5
			$BrickTimer.wait_time = max(newWaitTime, 0.5)

func spawnBall() -> Object:
	var ball = ball_scene.instantiate()
	ball.name = "Ball"
	ball.position = Vector2(360, 200)
	ball.ball_removed.connect(remove_ball)
	ball.updateSize(newBallSize)
	ball.updateSpeed(newBallSpeed)
	updateBallNumber(ball_count+1)
	add_child(ball)
	return ball

func spawnBricks() -> void:
	for i in range(block_num):
		var brick = brick_scene.instantiate()
		brick.name = "brick" + str(i)
		brick.position = Vector2(180 + 150 * i, 128)
		brick.block_destroyed.connect(increaseScore)
		brick.block_destroyed.connect(spawnPowerUp)
		brick.add_to_group("Hittable")
		add_child(brick)

func spawnPowerUp(position: Vector2) -> void:
	var prob = randf()
	if (prob <= power_up_prob):
		var powerUp = power_up_scene.instantiate()
		powerUp.powerUpTriggered.connect(handlePowerUp)
		powerUp.position = position
		powerUp.add_to_group("Hittable")
		
		add_child(powerUp)

func increaseScore(_position: Vector2) -> void:
	updateScore(score + 1)

func startGame() -> void:
	is_game_over = false
	timePassed = 0
	block_num = 6
	newBallSize = 1
	newBallSpeed = 1
	updateBallNumber(0)
	updateScore(0)
	lastBall = spawnBall()
	spawnBricks()
	$Paddle.reset()
	get_tree().call_group("Balls", "reset")
	$GameTimer.start()
	$BrickTimer.start()
	$Camera2D.zoom = Vector2(1.5, 1.5)

func remove_ball() -> void:
	$LossSound.play()
	updateBallNumber(ball_count - 1)
	if (ball_count == 0):
		endGame()

func endGame() -> void:
	var shouldEnd = true
	Global.new_max_score(score)
	if (shouldEnd):
		$BrickTimer.stop()
		$GameTimer.stop()
		$GUI/Score.text = "Game Over\nPress space to restart"
		is_game_over = true
		get_tree().call_group("Bricks", "queue_free")
		get_tree().call_group("Balls", "queue_free")
		get_tree().call_group("PowerUps", "queue_free")
		get_tree().change_scene_to_file.bind("res://scenes/menu.tscn").call_deferred()

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

func handlePowerUp(powerUpType: int) -> void:
	$PowerUpSound.play()
	if (powerUpType == -2):
		$Paddle.update_size(0.85)
	elif (powerUpType == -1):
		updateBallsSize(0.85)
	elif (powerUpType == 0):
		$Paddle.increase_speed()
	elif (powerUpType == 1):
		$Paddle.update_size(1.15)
	elif (powerUpType == 2):
		spawnBall()
	elif (powerUpType == 3):
		updateBallsSpeed(1.15)
	else:
		updateBallsSize(1.15)
		
func updateBallsSize(updatingBallSize: float) -> void:
	newBallSize *= updatingBallSize
	get_tree().call_group("Balls", "updateSize", newBallSize)

func updateBallsSpeed(updatingBallSpeed: float) -> void:
	newBallSpeed *= updatingBallSpeed
	get_tree().call_group("Balls", "updateSpeed", newBallSpeed)

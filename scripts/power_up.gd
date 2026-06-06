extends RigidBody2D

signal powerUpTriggered
var powerUpType;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	powerUpType = randi_range(-2,4)
	if (powerUpType < 0):
		$ColorRect.color = Color(255,0,0)
	if (powerUpType == -2):
		$Label.text = "PL"
	elif (powerUpType == -1):
		$Label.text = "BS"
	elif (powerUpType == 0):
		$Label.text = "PS"
	elif (powerUpType == 1):
		$Label.text = "PL"
	elif (powerUpType == 2):
		$Label.text = "+1"
	elif (powerUpType == 3):
		$Label.text = "BP"
	else:
		$Label.text = "BZ"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var collide = move_and_collide(Vector2(0,2))
	if (collide):
		powerUpTriggered.emit(powerUpType)
		queue_free()

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()

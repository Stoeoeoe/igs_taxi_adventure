extends KinematicBody2D

export(float) var speed = 1
var move_vector = Vector2(0,0)
var is_player = true

func _ready():
	set_process(true)
	
func _process(delta):
	if Input.is_action_pressed("up"):
		move_vector = Vector2(0, abs(speed) *-1 * delta)
		self.move(move_vector)
	if Input.is_action_pressed("down"):
		move_vector = Vector2(0, abs(speed) * delta )
		self.move(move_vector)
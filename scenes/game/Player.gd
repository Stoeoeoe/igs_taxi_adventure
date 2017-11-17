extends KinematicBody2D

export(float) var speed = 400
var move_vector = Vector2(0,0)
var height = 0



func _ready():
	set_process(true)
	set_process_input(true)
	self.height = get_node("CollisionShape2D").get_shape().get_extents().height * get_scale().y
	
	
func _input(event):
	if event.is_action_released("ui_accept") and not GameState.balls_launched:
		get_tree().call_group(0, "ball", "launch")
		
	
func _process(delta):
	if Input.is_action_pressed("up"):
		move_vector = Vector2(0, abs(speed) *-1 * delta)
		self.move(move_vector)
	if Input.is_action_pressed("down"):
		move_vector = Vector2(0, abs(speed) * delta )
		self.move(move_vector)

func kill():
	hide()
	queue_free()
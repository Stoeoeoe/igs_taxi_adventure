extends KinematicBody2D

export(float) var speed = 400
var move_vector = Vector2(0,0)
var height = 0

onready var single_bar = get_node("SingleBar")
onready var double_bar = get_node("DoubleBar")
onready var triple_bar = get_node("TripleBar")

func _ready():
	set_process(true)
	set_process_input(true)
	single_bar.show()
	double_bar.hide()
	triple_bar.hide()
	#self.height = get_node("CollisionShape2D").get_shape().get_extents().height * get_scale().y
	GameState.connect("powerup_collected", self, "handle_powerup", [])

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
	
func handle_powerup(powerup_id, arg1, arg2):
	if "multiply_board" in powerup_id:
		var number_of_boards = int(powerup_id.replace("multiply_board_", ""))
		if number_of_boards == 1:
			single_bar.show()
			double_bar.hide()
			triple_bar.hide()
		elif number_of_boards == 2:
			single_bar.hide()
			double_bar.show()
			triple_bar.hide()
		elif number_of_boards == 3:
			single_bar.hide()
			double_bar.hide()
			triple_bar.show()
			

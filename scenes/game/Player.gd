extends KinematicBody2D

export(float) var speed = 400
var move_vector = Vector2(0,0)
var height = 0
var movement_enabled = true;
var time_passed= 0.0
var current_stop_time = 0.0

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
	GameState.connect("game_finished", self, "stop_movement", [-1])
	

func _input(event):
	if event.is_action_released("ui_accept") and not GameState.balls_launched:
		get_tree().call_group(0, "ball", "launch")
		
	
func _process(delta):
	if movement_enabled:
		if Input.is_action_pressed("up"):
			move_vector = Vector2(0, abs(speed) *-1 * delta)
			self.move(move_vector)
		if Input.is_action_pressed("down"):
			move_vector = Vector2(0, abs(speed) * delta )
			self.move(move_vector)
	else:
		time_passed += delta
		if time_passed >= current_stop_time and current_stop_time >= 0: # < 0 is infinite
			movement_enabled = true

func stop_movement(pause_time):
	current_stop_time = pause_time
	time_passed = 0.0
	movement_enabled = false

func kill():
	hide()
	queue_free()
	
func handle_powerup(powerup_data):
	var powerup_id = powerup_data._id
	if "multiply_board" in powerup_id:
		var number_of_boards = powerup_data._custom_properties["boards"][1]
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
	elif "speed_up" in powerup_id:
		var speed_up_factor = powerup_data._custom_properties["factor"]
		pass
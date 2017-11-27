extends KinematicBody2D

export(float) var speed = 400
var move_vector = Vector2(0,0)
var height = 0
var movement_enabled = true
var time_passed= 0.0
var current_stop_time = 0.0

onready var single_bar = get_node("SingleBar")
onready var double_bar = get_node("DoubleBar")
onready var triple_bar = get_node("TripleBar")



func _ready():
	set_process(true)
	set_process_input(true)
	set_single_bar()
	self.height = 38
	GameState.connect("powerup_collected", self, "handle_powerup", [])
	GameState.connect("game_finished", self, "stop_movement", [-1])
	
func set_single_bar():
	single_bar.show()
	double_bar.hide()
	triple_bar.hide()
	single_bar.get_node("Bat1/CollisionShape2D").set_trigger(false)
	double_bar.get_node("Bat1/CollisionShape2D").set_trigger(true)
	double_bar.get_node("Bat2/CollisionShape2D").set_trigger(true)
	triple_bar.get_node("Bat1/CollisionShape2D").set_trigger(true)
	triple_bar.get_node("Bat2/CollisionShape2D").set_trigger(true)
	triple_bar.get_node("Bat3/CollisionShape2D").set_trigger(true)

func set_double_bar():
	single_bar.hide()
	double_bar.show()
	triple_bar.hide()
	single_bar.get_node("Bat1/CollisionShape2D").set_trigger(true)
	double_bar.get_node("Bat1/CollisionShape2D").set_trigger(false)
	double_bar.get_node("Bat2/CollisionShape2D").set_trigger(false)
	triple_bar.get_node("Bat1/CollisionShape2D").set_trigger(true)
	triple_bar.get_node("Bat2/CollisionShape2D").set_trigger(true)
	triple_bar.get_node("Bat3/CollisionShape2D").set_trigger(true)
			
func set_triple_bar():
	single_bar.hide()
	double_bar.hide()
	triple_bar.show()
	single_bar.get_node("Bat1/CollisionShape2D").set_trigger(true)
	double_bar.get_node("Bat1/CollisionShape2D").set_trigger(true)
	double_bar.get_node("Bat2/CollisionShape2D").set_trigger(true)
	triple_bar.get_node("Bat1/CollisionShape2D").set_trigger(false)
	triple_bar.get_node("Bat2/CollisionShape2D").set_trigger(false)
	triple_bar.get_node("Bat3/CollisionShape2D").set_trigger(false)



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
	
# Change this to handling of game_mode_changed (standard)
func handle_powerup(powerup_data):
	var powerup_id = powerup_data._id
	if "multiply_board" in powerup_id:
		var number_of_boards = powerup_data._custom_properties["boards"][1]
		if number_of_boards == 1:
			set_single_bar()
		elif number_of_boards == 2:
			set_double_bar()
		elif number_of_boards == 3:
			set_triple_bar()
	elif "speed_up" in powerup_id:
		var speed_up_factor = powerup_data._custom_properties["factor"]
		pass
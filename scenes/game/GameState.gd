extends Node
# Enums
enum POWER_MODE {default, half, double} # Power mode of the ball
enum SPEED_MODE {default, half, double} # Speed mode of the ball
enum PLAYER_COUNTER {default, two, three} # Number of player units (bats)
enum MODE_TYPE {power, speed, player}

# Scene definitions
var game_over_scene = "res://scenes/cutscenes/GameOver.tscn"
var intermediate_scene = "res://scenes/cutscenes/Intermediation.tscn"

# Constants
const NUMBER_OF_LEVELS = 8
const START_LIVES = 3

# Dynamic 
var current_level = 1
var current_score = 0
var remaining_lives = 0
var number_of_blocks_to_be_destroyed = 0
var balls_launched = false
var level_status = []

# Game modes (power-ups)
var current_power_mode = POWER_MODE.default
var current_speed_mode = SPEED_MODE.default
var current_player_count = PLAYER_COUNTER.default
var power_mode_duration = 0.0
var speed_mode_duration = 0.0
var player_count_duration = 0.0
var power_mode_time = 0.0
var speed_mode_time = 0.0
var player_count_time = 0.0
var power_mode_started = false
var speed_mode_started = false
var player_count_mode_started = false

# Signals
signal level_ready
signal game_finished
signal game_won
signal gameover
signal life_removed
signal life_added
signal powerup_collected(powerup_data)
signal game_mode_changed(mode, value, duration)
signal ball_killed(ball)



func _ready():
	randomize()
	connect("level_ready", self, "init_level", [])
	connect("ball_killed", self, "handle_ball_kill", [])
	connect("gameover", self, "handle_gameover")
	connect("powerup_collected", self, "handle_game_mode_change", [])
	init_game()
	set_process(true)
	
func _process(delta):
	if power_mode_started:
		power_mode_time += delta
		if power_mode_time > power_mode_duration and power_mode_duration > 0:
			current_power_mode = POWER_MODE.default
			emit_signal("game_mode_changed", MODE_TYPE.power, POWER_MODE.default, -1)
			power_mode_started = false
	if speed_mode_started:
		speed_mode_time += delta
		if speed_mode_time > speed_mode_duration and speed_mode_duration > 0:
			current_speed_mode = SPEED_MODE.default
			emit_signal("game_mode_changed", MODE_TYPE.speed, SPEED_MODE.default, -1)
			speed_mode_started = false
	if player_count_mode_started:
		player_count_time += delta
		if player_count_time > player_count_duration and player_count_duration > 0:
			current_player_count = PLAYER_COUNTER.default
			emit_signal("game_mode_changed", MODE_TYPE.player, PLAYER_COUNTER.default, -1)
			player_count_mode_started = false
	
func init_game():
	level_status.clear()
	for i in range(0, NUMBER_OF_LEVELS):
		level_status.append("LOCKED")
	level_status[0] = "UNLOCKED"
	set_lives(START_LIVES)
	
func init_level():
	HUD.clear_log()
	balls_launched = false
	current_power_mode = POWER_MODE.default
	current_speed_mode = SPEED_MODE.default
	current_player_count = PLAYER_COUNTER.default
	power_mode_started = false
	speed_mode_started = false
	player_count_mode_started = false

	# Create and count victory-relevant blocks
	var all_blocks = get_tree().get_nodes_in_group("block")
	for block in all_blocks:
		if block.block_data.victory_relevant:
			GameState.number_of_blocks_to_be_destroyed += 1
	pass
	HUD.set_title("CIRCUIT " + str(current_level) )
	

# Maps the data from the data editor to particular game modes
# Entities like Ball or Player can pick up the "game_mode_changed" signal
# If the game mode (e.g. x2 speed of ball) is timed, GameState resets the mode
# after the defined time (defined as property "Time" in the data editor" as long
# as the time is > 0. -1 means infinite time of the effect / game mode
func handle_game_mode_change(powerup_data):
	var mode
	var value
	var duration
	
	var powerup_id = powerup_data._id
	if "multiply_board" in powerup_id:
		mode = MODE_TYPE.player
		var number_of_boards = powerup_data._custom_properties["boards"][1]
		if number_of_boards == 2:
			value = PLAYER_COUNTER.two
		elif number_of_boards == 3:
			value = PLAYER_COUNTER.three
		else:
			value = PLAYER_COUNTER.default
		duration = powerup_data._custom_properties["time"][1]
		current_player_count = value
		player_count_duration = duration
		player_count_time = 0.0
		player_count_mode_started = true
	elif "multiply_speed" in powerup_id:
		mode = MODE_TYPE.speed
		var factor = powerup_data._custom_properties["factor"][1]
		if factor == 2.0:
			value = SPEED_MODE.double
		elif factor == 0.5:
			value = SPEED_MODE.half
		else:
			value = SPEED_MODE.default
		duration = powerup_data._custom_properties["time"][1]
		current_speed_mode = value
		speed_mode_duration = duration
		speed_mode_time = 0.0
		speed_mode_started = true
	elif "multiply_power" in powerup_id:
		mode = MODE_TYPE.power
		var factor = powerup_data._custom_properties["factor"][1]
		if factor == 2.0:
			value = POWER_MODE.double
		elif factor == 0.5:
			value = POWER_MODE.half
		else:
			value = POWER_MODE.default
		duration = powerup_data._custom_properties["time"][1]
		current_power_mode = value
		power_mode_duration = duration
		power_mode_time = 0.0
		power_mode_started = true
		
	emit_signal("game_mode_changed", mode, value, duration)

	
func add_score(score):
	current_score += score
	HUD.set_score(current_score)

func set_lives(number_of_lives):
	remaining_lives = number_of_lives
	HUD.set_lives(number_of_lives)

func add_life():
	remaining_lives += 1
	HUD.add_life()
	emit_signal("life_added")

func remove_life():
	remaining_lives -= 1
	HUD.remove_life()
	if remaining_lives == 0:
		emit_signal("gameover")
	else:
		emit_signal("life_removed")
	
func remove_block():
	number_of_blocks_to_be_destroyed -= 1
	if number_of_blocks_to_be_destroyed <= 0:
		trigger_game_won()
		
func trigger_game_won():
	HUD.write("Circuit Defragmentation completed!")
	emit_signal("game_finished")
	emit_signal("game_won")
	# MOVE ELSEWHERE PLEASE AND ALSO THE LAST LEVEL WILL CRASH
	level_status[current_level-1] = "COMPLETED"	
	level_status[current_level] = "UNLOCKED" if level_status[current_level] else "COMPLETED"	

func handle_gameover():
	HUD.write("Circuit Defragmentation failed. Self-Destruction initiated!")
	emit_signal("game_finished")

	current_score = 0
	#get_tree().change_scene(game_over_scene)
	
func handle_ball_kill(killed_ball):
	killed_ball.kill()
	var remaining_balls = get_tree().get_nodes_in_group("ball").size() - 1
	if remaining_balls == 0:
		remove_life()
		if remaining_lives > 0:	
			get_tree().call_group(0, "player", "kill")
			HUD.write("Defrag attempt failed - retry.")	
			balls_launched = false
	
func handle_game_over():
	SceneSwitcher.change_scene(game_over_scene)
	init_game()
	

func go_to_intermediate_scene():
	SceneSwitcher.change_scene(intermediate_scene)
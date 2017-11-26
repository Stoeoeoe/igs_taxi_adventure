extends Node

var current_score = 0
var number_of_blocks_to_be_destroyed = 0
var game_over_scene = "res://scenes/cutscenes/gameOver.tscn"
var intermediate_level = "res://scenes/cutscenes/Intermediation.tscn"

var start_lives = 3
var remaining_lives = 0
var balls_launched = false
var current_level = 1

var level_status = []

signal game_finished
signal game_won
signal game_lost
signal life_removed
signal life_added

var number_of_levels = 8

signal powerup_collected(powerup_data)

func _ready():
	for i in range(0, number_of_levels):
		level_status.append("LOCKED")
	level_status[0] = "UNLOCKED"
	randomize()

func initialize_game():
	for i in range(0, start_lives):
		add_life()
		

func reinitialize_game():
	start_lives = 3
	remaining_lives = 0
	balls_launched = false
	current_score = 0
	number_of_blocks_to_be_destroyed = 0

func add_score(score):
	current_score += score
	HUD.set_score(current_score)

func add_life():
	remaining_lives += 1
	HUD.add_life()
	emit_signal("life_added")

func remove_life():
	emit_signal("life_removed")
	remaining_lives -= 1
	HUD.remove_life()
	if remaining_lives == 0:
		trigger_gameover()
	
func remove_block():
	number_of_blocks_to_be_destroyed -= 1
	if number_of_blocks_to_be_destroyed <= 0:
		trigger_game_won()
		
func trigger_game_won():
	HUD.write("Circuit Defragmentation completed (You won!)")
	emit_signal("game_finished")
	emit_signal("game_won")
	# MOVE ELSEWHERE PLEASE AND ALSO THE LAST LEVEL WILL CRASH
	level_status[current_level-1] = "COMPLETED"	
	level_status[current_level] = "UNLOCKED" if level_status[current_level] else "COMPLETED"	

func trigger_gameover():
	HUD.write("Circuit Defragmentation failed. Self-Destruction initiated (GAME OVER!)")
	emit_signal("game_finished")
	emit_signal("game_lost")
	#get_tree().change_scene(game_over_scene)
	
	
func go_to_game_over_scene():
	SceneSwitcher.change_scene(game_over_scene)

func go_to_intermediate_scene():
	SceneSwitcher.change_scene(intermediate_level)
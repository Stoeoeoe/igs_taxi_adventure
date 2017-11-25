extends Node

var current_score = 0
var number_of_blocks_to_be_destroyed = 0
var game_over_scene = "res://scenes/cutscenes/gameOver.tscn"
var intermediate_level = "res://scenes/cutscenes/Intermediation.tscn"

var start_lives = 3
var remaining_lives = 0
var balls_launched = false
var current_level = 1

signal game_finished
signal game_won
signal game_lost
signal life_removed
signal life_added

signal powerup_collected(powerup_data)

func _ready():
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
	emit_signal("live_added")

func remove_life():
	emit_signal("life_removed")
	remaining_lives -= 1
	HUD.remove_life()
	if remaining_lives == 0:
		trigger_gameover()
	
func remove_block():
	number_of_blocks_to_be_destroyed -= 1
	if number_of_blocks_to_be_destroyed <= 0:
		HUD.write("You won!")
		emit_signal("game_finished")
		emit_signal("game_won")
		#pass
		#get_tree().change_scene(intermediate_level)

func trigger_gameover():
	HUD.write("GMAE OVER")
	emit_signal("game_finished")
	emit_signal("game_lost")
	#get_tree().change_scene(game_over_scene)
	
	
func go_to_game_over_scene():
	get_tree().change_scene(game_over_scene)

func go_to_inermediate_scene(level_number):
	current_level = level_number
	get_tree().change_scene(intermediate_level)
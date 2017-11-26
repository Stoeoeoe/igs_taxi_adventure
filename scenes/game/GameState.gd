extends Node

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

signal level_ready
signal game_finished
signal game_won
signal game_lost
signal life_removed
signal life_added
signal powerup_collected(powerup_data)



func _ready():
	randomize()
	
	for i in range(0, NUMBER_OF_LEVELS):
		level_status.append("LOCKED")
	level_status[0] = "UNLOCKED"
	set_lives(START_LIVES)
	connect("level_ready", self, "init_level", [])

func init_level():
	HUD.clear_log()
	balls_launched = false
	# Create and count victory-relevant blocks
	var all_blocks = get_tree().get_nodes_in_group("block")
	for block in all_blocks:
		if block.block_data.victory_relevant:
			GameState.number_of_blocks_to_be_destroyed += 1
	pass
	HUD.set_title("CIRCUIT " + str(current_level) )
	
	

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
	current_score = 0
	#get_tree().change_scene(game_over_scene)
	
	
func go_to_game_over_scene():
	SceneSwitcher.change_scene(game_over_scene)

func go_to_intermediate_scene():
	SceneSwitcher.change_scene(intermediate_scene)
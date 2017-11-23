extends Node

var current_score = 0
var number_of_blocks_to_be_destroyed = 0
var game_over_scene = "res://scenes/cutscenes/gameOver.tscn"
var intermediate_level = "res://scenes/cutscenes/Intermediation.tscn"

var start_lives = 3
var remaining_lives = 0
var balls_launched = false


signal powerup_collected(powerup_id, arg1, arg2)

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
	pass

func remove_life():
	remaining_lives -= 1
	HUD.remove_life()
	if remaining_lives == 0:
		trigger_gameover()
	
func remove_block():
	number_of_blocks_to_be_destroyed -= 1
	if number_of_blocks_to_be_destroyed <= 0:
		HUD.write("You won!")
		##PASS
		get_tree().change_scene(intermediate_level)

func trigger_gameover():
	HUD.write("GMAE OVER")
	get_tree().change_scene(game_over_scene)
	

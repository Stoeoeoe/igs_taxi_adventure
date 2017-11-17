extends Node

var current_score = 0
var number_of_blocks_to_be_destroyed = 0

var start_lives = 3
var remaining_lives = 1
var balls_launched = false


func _ready():
	var settings = preload("res://scenes/game/Settings.gd")
	settings.read_config()
	for i in range(0, start_lives-1):
		add_life()
		
func add_score(score):
	current_score += score
	HUD.set_score(current_score)

func add_life():
	remaining_lives += 1
	HUD.add_life()

func remove_life():
	remaining_lives -= 1
	HUD.remove_life()
	if remaining_lives == 0:
		trigger_gameover()
	
func remove_block():
	number_of_blocks_to_be_destroyed -= 1
	if number_of_blocks_to_be_destroyed <= 0:
		HUD.write("You won!")

func trigger_gameover():
	HUD.write("GMAE OVER")

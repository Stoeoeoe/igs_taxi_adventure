extends Node

var current_score = 0
var number_of_blocks_to_be_destroyed = 0
		
func add_score(score):
	current_score += score
	HUD.set_score(current_score)


	
func remove_block():
	number_of_blocks_to_be_destroyed -= 1
	if number_of_blocks_to_be_destroyed <= 0:
		HUD.out("You won!")

var balls_launched = false
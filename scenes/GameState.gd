extends Node

var current_score = 0

func _ready():
	pass
	
func add_score(score):
	current_score += score
	HUD.set_score(current_score)

var balls_launched = false
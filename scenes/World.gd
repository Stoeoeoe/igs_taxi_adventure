extends Node

var ball_class = preload("ball.tscn")
var player_class = preload("player.tscn")


func _ready():
	randomize()
	set_process(true)
	initialize_game()
	
	
func initialize_game():
	var player = player_class.instance()
	var ball = ball_class.instance()
	
	var player_pos = Vector2(80, 400) 
	player.set_pos(player_pos)
	player.speed = 400
	
	var ball_pos = player_pos + Vector2(ball.initial_margin_to_player, 0)
	ball.set_pos(ball_pos)
	ball.current_player = player
	
	self.add_child(player)
	self.add_child(ball)
	
	var all_blocks = get_node("Blocks").get_children()
	for block in all_blocks:
		if block.block_data.victory_relevant:
			GameState.number_of_blocks_to_be_destroyed += 1
	
	
func _process():
	pass
	

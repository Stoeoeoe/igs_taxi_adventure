extends Node

var ball_class = preload("ball.tscn")
var player_class = preload("player.tscn")
var initial_player_pos = Vector2(80, 400)  

func _ready():
	HUD.show_gameoverlay()
	randomize()
	set_process(true)
	initialize_game()
	var show_crt = Globals.get("settings.visual.crt")
	print(show_crt)
	
func initialize_game():
	HUD.show_hud()
	respawn_ball()
	
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.move()
		
	for powerup in get_tree().get_nodes_in_group("powerup"):
		pass
			
	
	# Create and count victory-relevant blocks
	var all_blocks = get_node("Blocks").get_children()
	for block in all_blocks:
		if block.block_data.victory_relevant:
			GameState.number_of_blocks_to_be_destroyed += 1


# Kill all balls, create new ones and respawn one
func respawn_ball():
	var player = player_class.instance()
	var ball = ball_class.instance()

	player.set_pos(initial_player_pos)
	player.speed = 400
	
	var ball_pos = initial_player_pos + Vector2(ball.initial_margin_to_player, 0)
	ball.set_pos(ball_pos)
	ball.current_player = player

	self.add_child(player)
	self.add_child(ball)

func _process():
	pass
	

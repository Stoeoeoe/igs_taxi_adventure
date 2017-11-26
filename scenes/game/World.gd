extends Node

var ball_class = preload("ball.tscn")
var player_class = preload("player.tscn")
var initial_player_pos = Vector2(80, 400)  

func _ready():
	initialize_game()
	GameState.emit_signal("level_ready")
	set_process(true)
	
func initialize_game():
	spawn_ball()
	
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.move()
		
	for powerup in get_tree().get_nodes_in_group("powerup"):
		pass
			


# Kill all balls, create new ones and respawn one
func spawn_ball():
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
	

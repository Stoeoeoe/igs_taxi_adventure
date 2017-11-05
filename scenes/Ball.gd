extends KinematicBody2D

export(int) var id = 0
export(float) var initial_speed = 140

var initial_margin_to_player = 20

var initial_direction = Vector2(1, 0)

var ball_launched = false
var current_player = null

var current_speed = 0
var rotation_speed = 70
var current_direction = Vector2(0,0)
var current_power_up = ''

onready var sound = get_node("SamplePlayer2D")

func _ready():
	set_process_input(true)
	self.current_direction = initial_direction
	self.current_speed = initial_speed
	set_process(true)

func _process(delta):
	if ball_launched:
		# If position did not change, bounce back and slightly change 
		if self.is_colliding() and get_collider():
			var collider = get_collider()
			_play_sound(collider)

			if collider.is_in_group("player"):
				player_bouncing()
			else:
				var bounce_variation = rand_range(-0.05, 0.05)
				default_bouncing(Vector2(bounce_variation, bounce_variation))
		
		self.move(current_direction * current_speed * delta)			
	


	else:
		# Move the ball along the bar§
		if current_player:
			var new_position = current_player.get_pos() + Vector2(initial_margin_to_player, 0)
			set_pos(new_position)

		

func launch():
	self.initial_direction = Vector2(1, rand_range(0, 1))
	self.ball_launched = true
		
func _play_sound(collider):
	if collider.is_in_group("player"):
		sound.play("player_hit")

	elif collider.is_in_group("wall"):
		sound.play("wall_hit")

func player_bouncing():
	var collider = get_collider()
	var delta_to_player_center = get_collision_pos().y - collider.get_pos().y
	var height_of_player = collider.height
	var distance_ratio = delta_to_player_center/ height_of_player
	self.current_direction = Vector2(initial_direction.x, distance_ratio)

	
func default_bouncing(bounce_variation = Vector(0,0)):
	var collision_normal = self.get_collision_normal()
	var x_coll = round(collision_normal.x)
	var y_coll = round(collision_normal.y)
	HUD.out(Vector2(x_coll, y_coll))	
	
	# Touched east
	if (x_coll == -1 or x_coll == 1) and y_coll == 0:
		self.current_direction = Vector2(-self.current_direction.x, self.current_direction.y + bounce_variation.y)
	# Touched west
	elif x_coll == 0 and (y_coll == 1 or y_coll == -1):
		self.current_direction = Vector2(self.current_direction.x + bounce_variation.x, -self.current_direction.y)
	# Touched north-west
	elif x_coll == -1 and y_coll == -1:
		self.current_direction = Vector2(-self.current_direction.x, self.current_direction.y + bounce_variation.y)
	# Touched north-east
	elif x_coll == -1 and y_coll == 1:
		self.current_direction = Vector2(-self.current_direction.x, self.current_direction.y + bounce_variation.y)
	# Touched south-west
	elif x_coll == 1 and y_coll == -1:
		self.current_direction = Vector2(-self.current_direction.x, self.current_direction.y + bounce_variation.y)
	# Touched south-east
	elif x_coll == 1 and y_coll == 1:
		self.current_direction = Vector2(-self.current_direction.x, self.current_direction.y + bounce_variation.y)
	else:
		HUD.out("Bouncing buggy!")


func _input(event):
	if event.is_action_released("faster"):
		self.current_speed *= 2
	if event.is_action_released("slower"):
		self.current_speed *= 0.5
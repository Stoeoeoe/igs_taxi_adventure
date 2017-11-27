extends KinematicBody2D

export(int) var id = 0
export(float) var initial_speed = 140

var initial_margin_to_player = 20

var initial_direction = Vector2(1, 0.25)

var ball_launched = false
var current_player = null

var current_speed = 0
var rotation_speed = 70
var current_direction = Vector2(0,0)
var current_power_up = ''
var movement_enabled = true
var power_mode_enabled = false
var weak_mode_enabled = false

onready var sample_player = get_node("SamplePlayer")
onready var power_hit_sprite = get_node("PowerHitSprite")

func _ready():
	set_process_input(true)
	self.current_direction = initial_direction
	self.current_speed = initial_speed
	GameState.connect("game_finished", self, "disrupt_ball")
	#GameState.connect("powerup_collected", self, "handle_powerup", [])
	GameState.connect("game_mode_changed", self, "handle_game_mode")
	set_process(true)

func _process(delta):
	if movement_enabled:
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
			# Move the ball along the bar
			if current_player:
				var new_position = current_player.get_pos() + Vector2(initial_margin_to_player, 0)
				set_pos(new_position)

func kill():
	hide()
	queue_free()
	
func disrupt_ball():
	movement_enabled = false
	get_node("Particles2D").set_emitting(true)
	get_node("Particles2D2").set_emitting(true)
	get_node("ExplosionSprite").show()
	get_node("ExplosionSprite").play()
	get_node("AnimatedSprite").hide()
	#queue_free() # why does everything disappear?

func launch():
	self.initial_direction = Vector2(1, rand_range(0, 1))
	self.ball_launched = true
		
func _play_sound(collider):
	if collider.is_in_group("player"):
		sample_player.play("player_hit")

	elif collider.is_in_group("wall"):
		sample_player.play("wall_hit")

func player_bouncing():
	var collider = get_collider()
	var collision_pos = get_collision_pos().y
	var collider_pos = collider.get_global_pos().y
	var delta_to_player_center = collision_pos / collider_pos
	var height_of_player = collider.get_parent().get_parent().height

	var distance_ratio = delta_to_player_center/ height_of_player
	self.current_direction = Vector2(initial_direction.x, distance_ratio)
	if power_mode_enabled:
		power_hit_sprite.set_modulate(Color(0,1,0,1))
		power_hit_sprite.play()

	
func default_bouncing(bounce_variation = Vector(0,0)):
	var collision_normal = self.get_collision_normal()
	var x_coll = round(collision_normal.x)
	var y_coll = round(collision_normal.y)
	var collider = get_collider()
	if power_mode_enabled and (collider.is_in_group("enemy") or collider.is_in_group("is_block")):
		power_hit_sprite.set_modulate(Color(1,0,0,1))
		power_hit_sprite.play()	
	
	
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


func _input(event):
	if event.is_action_released("faster"):
		self.current_speed *= 2
	if event.is_action_released("slower"):
		self.current_speed *= 0.5
		
func handle_powerup(powerup_data):
	pass

# Handles power-ups and power-downs according to signal from GameState
func handle_game_mode(mode, value, duration):
	if mode == GameState.MODE_TYPE.speed:
		if value == GameState.SPEED_MODE.double:
			self.current_speed = initial_speed * 2
		elif value == GameState.SPEED_MODE.half:
			self.current_speed = initial_speed / 2
		else:
			self.current_speed = initial_speed
	elif mode == GameState.MODE_TYPE.power:
		if value == GameState.POWER_MODE.double:
			power_hit_sprite.show()
			power_mode_enabled = true
			weak_mode_enabled = false
		elif value == GameState.POWER_MODE.half:
			power_hit_sprite.hide()
			power_mode_enabled = false
			weak_mode_enabled = true
		else:
			power_hit_sprite.hide()
			power_mode_enabled = false
			weak_mode_enabled = false

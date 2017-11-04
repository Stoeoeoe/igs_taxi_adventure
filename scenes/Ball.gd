extends KinematicBody2D

export(int) var id = 0
export(float) var initial_speed = 140
var initial_direction = Vector2(1, 0.2)

var current_speed = 0
var current_direction = Vector2(0,0)
var current_power_up = ''

onready var sound = get_node("SamplePlayer2D")

func _play_sound(collider):
	if collider.get("is_player"):
		sound.play("player_hit")
	elif collider.get("is_enemy"):
		sound.play("enemy_hit")
	else:
		sound.play("wall_hit")


func _ready():
	set_collision_margin(1)
	set_process_input(true)
	self.current_direction = initial_direction
	self.current_speed = initial_speed
	set_process(true)

func _process(delta):
	self.move(current_direction * current_speed * delta)
	#self.move_and_slide(current_direction * current_speed, self.get_collision_normal())
	if self.is_colliding():
		# If colliding with a player, randomize
		var collider = get_collider()
		if collider.get("is_player"):

			HUD.out(get_collision_pos().y - self.get_pos().y)
			
		_play_sound(collider)
		#sound.play("wall_hit")		
		var collision_normal = self.get_collision_normal()
		var x_coll = round(collision_normal.x)
		var y_coll = round(collision_normal.y)
		HUD.out(str(collision_normal))
		
		# Touched right object
		if (x_coll == -1 or x_coll == 1) and y_coll == 0:
			self.current_direction = Vector2(-self.current_direction.x, self.current_direction.y)
		elif x_coll == 0 and (y_coll == 1 or y_coll == -1):
			self.current_direction = Vector2(self.current_direction.x, -self.current_direction.y)
		

func _input(event):
	if event.is_action_released("faster"):
		self.current_speed *= 2
	if event.is_action_released("slower"):
		self.current_speed *= 0.5
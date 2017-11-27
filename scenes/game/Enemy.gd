tool

extends KinematicBody2D

export(Sample) var hit_sound setget set_hit_sound
export(Texture) var default_texture = load("assets/imgs/enemies/default_enemy.png") setget set_default_texture
export(int, "STATIC", "RANDOM", "STRAIGT_TO_EXIT", "STRAIGHT_TO_PLAYER")  var movement_behavior = 0 setget set_movement_behavior
export(float) var movement_speed = 1.0 setget set_movement_speed
export(float) var random_factor = 50.0 setget set_random_factor
export(float) var flash_frquency = 5.0 setget set_flash_frequency
export(float) var flash_length = 1.0 setget set_flash_length
export(bool) var flash_on_ball_hit setget set_flash_on_ball_hit
export(int) var number_of_hits_to_destroy = -1 setget set_number_of_hits_to_destroy
export(String) var enemy_type = "default" setget set_enemy_type

onready var sample_player = get_node("SamplePlayer2D")
onready var sprites = get_node("AnimatedSprite")
onready var sprite = get_node("Sprite")
onready var tween = get_node("Tween")
onready var raycast = get_node("RayCast2D")

var temp_pos = Vector2(0,2)
var last_pos = Vector2(0,0)
var flash_started = false
var flash_sub_duration = 0.0
var time_delta = 0.0
var time_sub_delta = 0.0
var original_modulation = Color(1,1,1)
var number_of_hits = 0


func set_enemy_type(new_enemy_type):
	enemy_type = new_enemy_type

func set_number_of_hits_to_destroy(number_of_hits):
	number_of_hits_to_destroy = number_of_hits

func set_hit_sound(new_hit_sound):
	hit_sound = new_hit_sound
	
func set_default_texture(new_default_texture):
	default_texture = new_default_texture

func set_movement_behavior(new_movement_behavior):
	movement_behavior = new_movement_behavior

func set_movement_speed(new_movement_speed):
	movement_speed = new_movement_speed

func set_random_factor(new_random_factor):
	random_factor = new_random_factor

func set_flash_frequency(new_flash_frequency):
	flash_frquency = new_flash_frequency
	
func set_flash_length(new_flash_length):
	flash_length = new_flash_length

func set_flash_on_ball_hit(new_flash_on_ball_hit):
	flash_on_ball_hit = new_flash_on_ball_hit
	if new_flash_on_ball_hit:
		flash_enemy()

func _ready():
	var sample_library = SampleLibrary.new()
	sample_player.set_sample_library(sample_library)
	if hit_sound:
		sample_player.get_sample_library().add_sample("hit_sound", hit_sound)
	
	if default_texture:
		sprite.set_texture(default_texture)
	#var sprite_frames = SpriteFrames.new()
	#sprite_frames.set_frame("default", 0, base_sprite)
	#sprites.set_sprite_frames(sprite_frames)
	#sprites.set_animation("default")
	set_process(true)

#tween.interpolate_property(get_node("Node2D_to_move"), "transform/pos", Vector2(0,0), Vector2(100,100), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)

#tween.start()

func flash_enemy():
	if flash_on_ball_hit:
		flash_started = true
		if flash_frquency == 0:
			flash_sub_duration = 1 / 0.001
		else: 
			flash_sub_duration = 1 / flash_frquency
		if sprite:
			original_modulation = sprite.get_modulate()
		time_sub_delta = 0
		time_delta = 0
	pass
	

func move():
	var pos_enemy = get_pos()
	if movement_behavior == 1: # random
		set_new_random_position(pos_enemy, false)
	elif movement_behavior == 2: # exit
		var end_point = Vector2(-100, pos_enemy.y)
		tween.interpolate_property(self,"transform/pos", pos_enemy, end_point, movement_speed, Tween.TRANS_LINEAR, Tween.EASE_IN)
		tween.start();
	elif movement_behavior == 3: # player
		var players =  get_tree().get_nodes_in_group("player")
		var player_index = randi() % players.size()
		var pos_player = players[player_index].get_pos()
		var end_point = get_end_pos(pos_player, 20000)
		tween.interpolate_property(self,"transform/pos", pos_enemy, end_point, movement_speed, Tween.TRANS_LINEAR, Tween.EASE_IN)
		tween.start()	

func _process(delta):
	if movement_behavior == 1: # random
		var pos_enemy = get_pos()
		if pos_enemy.x == temp_pos.x and pos_enemy.y == temp_pos.y:
			set_new_random_position(pos_enemy, false)
	if flash_started:
		time_delta += delta
		time_sub_delta += delta
		if time_sub_delta >= flash_sub_duration:
			sprite.set_modulate(Color(rand_range(0,1),rand_range(0,1),rand_range(0,1)))
			time_sub_delta = 0
		if time_delta >= flash_length:
			sprite.set_modulate(original_modulation)
			flash_started = false
		
			

func get_end_pos(target_objec_pos, distance_factor):
	var pos_enemy = get_pos()
	var direction = (pos_enemy - target_objec_pos).normalized() 
	var distance = pos_enemy.distance_to(target_objec_pos ) * distance_factor
	raycast.set_cast_to(pos_enemy - (direction*distance))
	raycast.force_raycast_update()
	return raycast.get_collision_point()
	
func set_new_random_position(pos_enemy, reverse):
	if reverse:
		#var direction = (pos_enemy - temp_pos).normalized()
		#var distance = pos_enemy.distance_to(temp_pos)
		#print(distance * direction * -1)
		#temp_pos = ((distance * direction * -1)  + pos_enemy)
		temp_pos = last_pos
	else:
		last_pos = temp_pos
		temp_pos = Vector2(rand_range(pos_enemy.x-random_factor, pos_enemy.x+random_factor), rand_range(pos_enemy.y-random_factor, pos_enemy.y+random_factor))
	tween.interpolate_property(self,"transform/pos", pos_enemy, temp_pos, movement_speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()	

func _on_enemy_hit( body ):
	if body.is_in_group("ball"):
		sample_player.play("hit_sound")
		flash_enemy()
		number_of_hits += 1
	if movement_behavior == 1 and body.is_in_group("obstacles"):
		var pos_enemy = get_pos()
		set_new_random_position(pos_enemy, true)
	if number_of_hits >= number_of_hits_to_destroy:
		GameState.kill_enemy(enemy_type, self.get_instance_ID())
		kill()
		
func kill():
	hide()
	queue_free()

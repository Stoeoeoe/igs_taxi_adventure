extends Node

onready var bg = get_node("HyperspaceStage/Backdrop")
onready var lightning = get_node("HyperspaceStage/Lightning")
onready var animation_player = get_node("AnimationPlayer")
onready var sound_player = get_node("ThunderPlayer")
onready var camera = get_node("IGSCamera")
onready var bgm = get_node("StreamPlayer")
onready var hyperspace_stage = get_node("HyperspaceStage")
onready var normalspace_stage = get_node("NormalSpaceStage")

onready var flash_screen = get_node("FlashScreen")
onready var ship = get_node("Ship/ShipSprite")
onready var engine = get_node("Ship/Engine")

export var flash_length = 1.2
export var ship_flash_length = 0.2

var flash_started = false
var original_color = Color(1,1,1)
var time_delta = 0.0
var ratio2 = 0.0
var ratio = 0.0
var lightning_pos = 0;
var screen_width = OS.get_window_size().width
var original_shake_amount = 0.0
var disable_actions = false

var time_since_canvas_modulate = 0.0
var time_until_canvas_modulate = 0.25
var modulate_colors = [Color(1, 0.66, 0.66), Color(1, 0.66, 0.66), Color(0.9, 0.56, 0.56), Color(0.9, 0.56, 0.66), Color(0.75, 0.56, 0.56), Color(0.75, 0.4, 0.4)]
#onready var canvas_modulate = get_node("CanvasModulate")

func set_hyperspace_stage(enabled):
	if enabled:
		disable_actions = false
		hyperspace_stage.show()
		lightning.replay = true
		lightning.show()
		#set_shake(original_shake_amount)
	else:
		disable_actions = true
		hyperspace_stage.hide()
		lightning.replay = false
		original_shake_amount = get_shake()
		#set_shake(0)
		lightning.hide()
		
func set_ship_visibility(visible):
	if visible:
		ship.show()
		engine.show()
	else:
		ship.hide()
		engine.hide()

func set_ship_position(new_position):
	var engine_delta = ship.get_pos().x - new_position.x
	ship.set_pos(new_position)
	engine.set_pos(Vector2(engine.get_pos().x - engine_delta, engine.get_pos().y))
	
func get_ship_position():
	return ship.get_pos()
      
func set_ship_modulatuion(color):
	ship.set_modulate(color)

func set_engine_mode(color, length, position):
	engine.set_opacity(1.0)
	set_engine_type("Ship/Engine/FrameCyclerSprite1",color, length, position)
	set_engine_type("Ship/Engine/FrameCyclerSprite2",color, length, position)
	set_engine_type("Ship/Engine/FrameCyclerSprite3",color, length, position)
	set_engine_type("Ship/Engine/FrameCyclerSprite4",color, length, position)
	set_engine_type("Ship/Engine/FrameCyclerSprite5",color, length, position)
	set_engine_type("Ship/Engine/FrameCyclerSprite6",color, length, position)
	
	

func set_engine_type(name, col, len, pos):
	var eng
	eng = get_node(name)
	eng.set_modulate(col)
	eng.set_scale(Vector2(len, eng.get_scale().y))
	eng.set_pos(Vector2(eng.get_pos().x + pos, eng.get_pos().y))

func set_normalspace_stage(enabled):
	if enabled:
		normalspace_stage.show()	
	else:
		normalspace_stage.hide()
		
func set_normal_space_speed(speed):
	normalspace_stage.get_node("Spacemap").speed = speed
	normalspace_stage.get_node("ParallaxMap").speed = speed * 1.25


func set_ship_to_end_pos():
	animation_player.seek(39.8,false)

func set_shake(amount):
	camera.shake_amount = amount
	if amount == 0:
		camera.is_shaking = false
	
func get_shake():
	return camera.shake_amount
	
func get_bgm_level():
	return bgm.get_volume()
	
func set_bgm_level(new_level):
	bgm.set_volume(new_level)

func get_sfx_level():
	return sound_player.get_default_volume()
	
func set_sfx_level(new_level):
	sound_player.set_default_volume(new_level)

func _ready():
	HUD.hide_hud()
#	original_color = bg.get_modulate()
	animation_player.play("Cutscene")
	screen_width = OS.get_window_size().width
	set_process(true)


func _process(delta):
	if not disable_actions:
		if flash_started:
			time_delta += delta
			ratio = time_delta / flash_length
			ratio2 = time_delta  /ship_flash_length
			#bg.set_modulate(Color(1 - (1-original_color.r)*ratio, 1 - (1-original_color.g)*ratio, 1 - (1-original_color.b)*ratio))
			bg.set_opacity(1-ratio)
			flash_screen.set_modulate(Color(1 - ratio2, 1 - ratio2, 1 - ratio2))
			ship.set_modulate(Color(ratio2,ratio2,ratio2))
			engine.set_opacity(ratio2)
			
			if time_delta >= flash_length:
				#bg.set_modulate(original_color)
				flash_started = false
			if time_delta >= ship_flash_length:
				ship.set_modulate(Color(1,1,1))
				flash_screen.set_opacity(0)
				engine.set_opacity(1)

func _on_Lightning_flash_start():
	if not get_tree().is_editor_hint() and sound_player:
		sound_player.set_default_pitch_scale(rand_range(0.6,1.2))
		sound_player.play("thunder1")
		
		#sound_player.set_pitch_scale(0,rand_range(0.1,10))
		bg.set_opacity(1.0)
		#bg.set_modulate(Color(1,1,1))
		time_delta = 0.0
		flash_started = true
		flash_screen.set_opacity(1.0)
		ship.set_modulate(Color(0,0,0))
		engine.set_opacity(0)


func _on_Lightning_flash_end():
	if not get_tree().is_editor_hint():
		#bg.set_opacity(0.0)
		lightning_pos = rand_range(0, screen_width)
		lightning.set_pos(Vector2(lightning_pos, lightning.get_pos().y))

extends Node

onready var bg = get_node("Backdrop")
onready var lightning = get_node("Lightning")
onready var animation_player = get_node("AnimationPlayer")
onready var sound_player = get_node("ThunderPlayer")

onready var flash_screen = get_node("FlashScreen")
onready var ship = get_node("Ship/ShipSprite")
onready var engine = get_node("Ship/Engine")

var flash_length = 0.5
var ship_flash_length = 0.2
var flash_started = false
var original_color = Color()
var time_delta = 0.0
var ratio2 = 0.0
var ratio = 0.0
var lightning_pos = 0;
var screen_width = 1024

func _ready():
	original_color = bg.get_modulate()
	animation_player.play("Cutscene")
	screen_width = OS.get_window_size().width
	set_process(true)


func _process(delta):
	if flash_started:
		time_delta += delta
		ratio = time_delta / flash_length
		ratio2 = time_delta  /ship_flash_length
		bg.set_modulate(Color(1 - (1-original_color.r)*ratio, 1 - (1-original_color.g)*ratio, 1 - (1-original_color.b)*ratio))
		flash_screen.set_modulate(Color(1 - ratio2, 1 - ratio2, 1 - ratio2))
		ship.set_modulate(Color(ratio2,ratio2,ratio2))
		engine.set_opacity(ratio2)
		
		if time_delta >= flash_length:
			bg.set_modulate(original_color)
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
		bg.set_modulate(Color(1,1,1))
		time_delta = 0.0
		flash_started = true
		flash_screen.set_opacity(1.0)
		ship.set_modulate(Color(0,0,0))
		engine.set_opacity(0)
		


func _on_Lightning_flash_end():
	if not get_tree().is_editor_hint():
		lightning_pos = rand_range(0, screen_width)
		lightning.set_pos(Vector2(lightning_pos, lightning.get_pos().y))

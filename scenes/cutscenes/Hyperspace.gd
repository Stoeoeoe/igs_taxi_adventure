extends Node

onready var bg = get_node("Backdrop")
onready var lightning = get_node("Lightning")
onready var animation_player = get_node("AnimationPlayer")
onready var sound_player = get_node("TunderPlayer")

var flash_length = 0.5
var flash_started = false
var original_color = Color()
var time_delta = 0.0
var ratio = 0.0
var lightning_pos = 0;
var screen_width = 1024

func _ready():
	lightning.connect("flash_start", self, "flash_bg")
	lightning.connect("flash_end", self, "move_lightning")
	original_color = bg.get_modulate()
	animation_player.play("Cutscene")
	screen_width = OS.get_window_size().width
	set_process(true)

func flash_bg():
	sound_player.play("thunder1")
	bg.set_modulate(Color(1,1,1))
	time_delta = 0.0
	flash_started = true

func move_lightning():
	lightning_pos = rand_range(0, screen_width)
	lightning.set_pos(Vector2(lightning_pos, lightning.get_pos().y))

func _process(delta):
	if flash_started:
		time_delta += delta
		ratio = time_delta / flash_length
		bg.set_modulate(Color(1 - (1-original_color.r)*ratio, 1 - (1-original_color.g)*ratio, 1 - (1-original_color.b)*ratio))
		if time_delta >= flash_length:
			bg.set_modulate(original_color)
			flash_started = false

	
	
extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var bg = get_node("Backdrop")
onready var lightning = get_node("Lightning")

var flash_length = 0.5
var flash_started = false
var original_color = Color()
var time_delta = 0.0
var ratio = 0.0

func _ready():
	set_process(true)
	original_color = bg.get_modulate()
	HUD.deactivate()
	pass
	get_node("AnimationPlayer").play("ShakeTrack")
	lightning.connect("flash", self, "flash_bg")

func flash_bg():
	bg.set_modulate(Color(1,1,1))
	time_delta = 0.0;
	flash_started = true;
	
func _process(delta):
	if flash_started:
		time_delta += delta
		ratio = time_delta / flash_length
		bg.set_modulate(Color(1 - (1-original_color.r)*ratio, 1 - (1-original_color.g)*ratio, 1 - (1-original_color.b)*ratio))
		if time_delta >= flash_length:
			bg.set_modulate(original_color)
			flash_started = false

	
	
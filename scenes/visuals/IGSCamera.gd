tool
extends Camera2D

onready var timer = get_node("Timer") 
export var shake_amount = 1.0 setget set_shake_amount
export var is_shaking = false setget set_is_shaking

func set_shake_amount(new_shake_amount):
	shake_amount = new_shake_amount
	
func set_is_shaking(new_is_shaking):
	is_shaking = new_is_shaking

func _ready():
	Globals.set("camera", self)
	set_process(true)

func _process(delta):
	if is_shaking:
	    self.set_offset(Vector2( \
	    rand_range(-1.0, 1.0) * shake_amount, \
	    rand_range(-1.0, 1.0) * shake_amount \
	    ))

func shake(duration = 1.0, shake_amount = 5.0):
	self.shake_amount = shake_amount
	timer.stop()
	timer.set_wait_time(duration)
	timer.start()
	self.is_shaking = true


func _on_Timer_timeout():
	self.is_shaking = false

extends Node

onready var hyperspace = get_node("Hyperspace")
onready var space_player = get_node("SpacePlayer")

var time_passed = 0
var switched = false

func _ready():
	hyperspace.set_ship_to_end_pos()
	set_process(true)
	
func _process(delta):
	time_passed += delta
	if time_passed > 4 and switched == false:
		switch_stage()
		

func switch_stage():
	hyperspace.set_bgm_level(0.0)
	hyperspace.set_hyperspace_stage(false)
	hyperspace.set_normalspace_stage(true)
	space_player.play(0)
	hyperspace.set_shake(0.0)
	hyperspace.set_ship_modulatuion(Color(0.65,0.65,0.85))
	hyperspace.set_engine_mode(Color(1.2,1.2,5), 2, 10)
	switched = true
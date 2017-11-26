tool
extends KinematicBody2D

export(String, "EAST", "WEST", "SOUTH", "NORTH") var entry_side
onready var frame = get_node("Frame")


func _ready():
	set_process(true)
	Globals.set("entry_side", entry_side)
	
	
	if entry_side == 'EAST':
		frame.set_texture(preload('../../assets/imgs/stage_frame_east.png'))
		remove_child(get_node("EastCollision"))
	elif entry_side == 'WEST':
		frame.set_texture(preload('../../assets/imgs/stage_frame_west.png'))
		remove_child(get_node("WestCollision"))
			
func _process(delta):
	pass

# Out of the Kill zone == DEAD
func _on_Killzone_body_enter( body ):
	if body.is_in_group("ball"):
		var ball = body
		GameState.emit_signal("ball_killed", ball)

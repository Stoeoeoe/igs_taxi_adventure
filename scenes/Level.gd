tool
extends Node2D

export(String, "EAST", "WEST", "SOUTH", "NORTH") var entry_side

onready var frame = get_node("Frame")


func _ready():
	Globals.set("entry_side", entry_side)
	
	if entry_side == 'EAST':
		frame.set_texture(preload('../assets/imgs/stage_frame_east.png'))
		get_node("WestCollision").hide()
	elif entry_side == 'WEST':
		frame.set_texture(preload('../assets/imgs/stage_frame_west.png'))
		get_node("EastCollision").hide()

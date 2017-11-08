extends "res://addons/godot_data_editor/data_item.gd"

export(int, 0, 999999) var score = 0
export(Color) var block_color = Color(1,1,1)
export(Sample) var destruction_sample = null
export(Texture) var overlay = null
export(bool) var victory_relevant = true
export(int) var number_of_hits = 1

export(Texture) var background_sprite = null
export(int) var animation_h_frames = 1
export(int) var animation_v_frames = 1
export(float) var animation_speed = 0


func _init(id).(id):
	pass

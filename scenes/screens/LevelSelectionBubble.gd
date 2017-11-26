tool
extends Area2D

onready var level_number_label = get_node("LevelNumberLabel")
onready var sample_player = get_node("SamplePlayer")
onready var texture_frame = get_node("TextureFrame")

export(int) var level = 0 setget set_level
export(String, "UNLOCKED", "COMPLETED", "LOCKED") var status = "LOCKED" setget set_status


signal level_selected(level)
signal level_selected_failed(level)


func _ready():
	level_number_label.set_text(str(level))
	change_color()


# TODO: Fix
func _get_item_rect():
	if texture_frame:
		var texture_rect = texture_frame.get_rect()
		return Rect2(0, 0, texture_rect.size.width, texture_rect.size.height)

func set_level(new_level):
	level = new_level
	if level_number_label:
		level_number_label.set_text(str(level))
		
func set_status(new_status):
	status = new_status	
	if texture_frame:
		change_color()

func _on_LevelBubble_input_event( viewport, event, shape_idx ):
	if event.type == InputEvent.MOUSE_BUTTON and event.button_index == BUTTON_LEFT and not event.pressed :
		if status == "UNLOCKED" or status == "COMPLETED":
			sample_player.play("select_level")
			emit_signal("level_selected", level)
		else:
			sample_player.play("select_level_failed")
			emit_signal("level_selected_failed", level)

func change_color():
	if status == "UNLOCKED":
		texture_frame.set_modulate(Color(0.8,0.8,0))
	elif status == "LOCKED":
		texture_frame.set_modulate(Color(0.8,0,0))		
	elif status == "COMPLETED":
		texture_frame.set_modulate(Color(0,0.8,0))					
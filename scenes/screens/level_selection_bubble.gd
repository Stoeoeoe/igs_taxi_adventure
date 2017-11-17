tool
extends Area2D

onready var level_number_label = get_node("LevelNumberLabel")
onready var sample_player = get_node("SamplePlayer")
onready var texture_frame = get_node("TextureFrame")

export(int) var level = 0 setget set_level
export(bool) var unlocked = false setget set_unlocked

signal level_selected(level)
signal level_selected_failed(level)

# TODO: Fix
func _get_item_rect():
	var texture_rect = get_node("TextureFrame").get_rect()
	return Rect2(0, 0, texture_rect.size.width, texture_rect.size.height)

func set_level(new_level):
	level = new_level
	if level_number_label:
		level_number_label.set_text(str(level))
	
func set_unlocked(new_unlocked):
	unlocked = new_unlocked
	if level_number_label:
		level_number_label.set_opacity(1 if unlocked else 0.5)

func _ready():
	level_number_label.set_text(str(level))
	level_number_label.set_opacity(1 if unlocked else 0.5)

func _on_LevelBubble_input_event( viewport, event, shape_idx ):
	if event.type == InputEvent.MOUSE_BUTTON and event.button_index == BUTTON_LEFT and not event.pressed :
		if unlocked:
			sample_player.play("select_level")
			emit_signal("level_selected", level)
		else:
			sample_player.play("select_level_failed")
			emit_signal("level_selected_failed", level)
			
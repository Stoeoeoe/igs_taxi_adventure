extends Node

var target_level = "res://scenes/screens/LevelMenu.tscn"
var texts = StringArray()
var labels_texts = StringArray()
var face_sets = IntArray()

onready var hyperspace = get_node("Hyperspace")
onready var terminal = get_node("Terminal")
onready var faceset = get_node("CanvasLayer/FaceSet")
onready var faceset_frame = get_node("CanvasLayer/FaceSet/FaceFrame")
onready var continue_button = get_node("CanvasLayer/ContinueButton")
onready var faceset_label = get_node("CanvasLayer/FaceSet/Label")
onready var animation_player = get_node("AnimationPlayer")

var scene_idle = false
var dialog_position = -1
var end_position = -1


func _ready():
	hyperspace.set_ship_to_end_pos()
	set_process_input(true)
	animation_player.play("StartAnimation")
	#play()


func _on_Button_pressed():
	SceneSwitcher.change_scene(target_level)

func play():
	
	var level = GameState.current_level # Determine the right level
	if 	level == 1:
		setup_dialog1()
	elif level == 2:
		setup_dialog2()
		pass
		
	terminal.show_background = true
	continue_dialog()
		
	
func setup_dialog1():
	end_position = 3
	texts.append("""I did the first level """)
	texts.append("""Test""")
	texts.append("""Test 2""")
	labels_texts.append("Cpt. Tungsten")
	labels_texts.append("")
	labels_texts.append("")
	face_sets.append(0)
	face_sets.append(1)
	face_sets.append(2)
	
func setup_dialog2():
	end_position = 3
	texts.append("""I did the second level """)
	texts.append("""Test""")
	texts.append("""Test 2""")
	labels_texts.append("Cpt. Rabenheimer")
	labels_texts.append("")
	labels_texts.append("")
	face_sets.append(0)
	face_sets.append(1)
	face_sets.append(2)
	
func continue_dialog():
	scene_idle = false
	continue_button.hide()
	dialog_position = dialog_position + 1;
	if dialog_position >= end_position: # end
		SceneSwitcher.change_scene(target_level)
		return
	if face_sets[dialog_position] < 0:
		faceset.hide()
	else:
		faceset.show()
		faceset_frame.set_frame(face_sets[dialog_position])
		faceset_label.set_text(labels_texts[dialog_position])
	terminal.clear()
	terminal.start_writing(texts[dialog_position])

func _on_Terminal_text_finished():
	if not dialog_position >= 13:
		continue_button.show()
	scene_idle = true
	
func _input(event):
	if event.is_action_released("cutscene_skip"):
		SceneSwitcher.change_scene(target_level)
	elif event.is_action_released("cutscene_forward"):
		if scene_idle:
			continue_dialog()
		elif dialog_position >= 0:
			terminal.write_text_to_end()

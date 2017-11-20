extends Node

onready var animation_player = get_node("AnimationPlayer")
onready var terminal = get_node("Terminal")
onready var faceset = get_node("CanvasLayer/FaceSet")
onready var faceset_frame = get_node("CanvasLayer/FaceSet/FaceFrame")
onready var continue_button = get_node("CanvasLayer/ContinueButton")
onready var faceset_label = get_node("CanvasLayer/FaceSet/Label")
onready var canvas = get_node("CanvasModulate")
onready var hyperspace = get_node("Hyperspace")
onready var rift_player = get_node("RiftPlayer")

#var last_pos
var time_passed = 0.0
var sequence_started = false
var incident_started = false
var scene_idle = false
var dialog_position = -1
var current_color_value = 0.0
var shake_amount = 0.0
var sound_level = 1.0
var ship_flash_length = 0

var initial_delay = 3.0
var incident_delay = 6.0
var incident_flash_length = 0.8
var target_shake = 40.0
var target_level = "res://scenes/screens/MainMenu.tscn"
var texts = StringArray()
var labels_texts = StringArray()
var face_sets = IntArray()

func _input(event):
	if event.is_action_released("cutscene_skip"):
		get_tree().change_scene(target_level)
	elif event.is_action_released("cutscene_forward"):
		if scene_idle:
			continue_dialog()
		elif dialog_position >= 0:
			terminal.write_text_to_end()

func setup_dialog():
	texts.append("""2023 AD - Beta Hyperspace{0.8}\nThe interstellar carrier ''IHS Renegade'' is on the way to the ice moon Ilex in\nthe far-off Hibris system with an important cargo of Baranium Sulfide,\ndedicated to the Hyper-Mines of this inhospitable colony of mankind.""")
	texts.append("""Mission:{0.4}\nHyperspace carriage (Batch: BTS-SHD-788-B2S4){0.4}\nClient - Beyond the Skies (BTS)\n{0.4}Origin - Earth, Xin-Shanghai (Baranium refinery III){0.4}\nDestination - Hibris, Ilex (G3S479-P3-M7){0.4}""")
	texts.append("""Crew:{0.4}\nCpt. Wolfram Tungsten {0.4}[Human]{0.4}\nCELESTE {0.4}[Autonomous Electronic Brain]""")
	texts.append("""Captain, my sensors are detecting an anomaly.""")
	texts.append("""What is it, CELESTE?""")
	texts.append("""I don't know yet. It looks like a distortion in the Beta Hyperspace.""")
	texts.append("""That's impossible!""")
	texts.append("""Hold on for a second...{0.8}\nWarning! I detected a Hyperspace rift 1000 miles ahead!""")
	texts.append("""What!? {0.4}CELESTE, evasion maneuver!""")
	texts.append("""Too late...""")
	texts.append("") # dummy
	texts.append("""The ''IHS Renegade'' was hit by the rift, {0.4}the navigaton unit of the computer\nbrain lost control over the ship and was shut down.{0.5}\nThe only way to escape from the rift is to manually take over the\nHyperspace control of the ship and to navigate the ''IHS Renegade'' out of the\ndistorted Hyperspace.{0.8}""")
	texts.append("""...{0.8}This was never done by a human before...""")
	texts.append("") # dummy
	

	labels_texts.append("")
	labels_texts.append("")
	labels_texts.append("")
	labels_texts.append("CELESTE")
	labels_texts.append("Cpt. Tungsten")
	labels_texts.append("CELESTE")
	labels_texts.append("Cpt. Tungsten")
	labels_texts.append("CELESTE")
	labels_texts.append("Cpt. Tungsten")
	labels_texts.append("CELESTE")
	labels_texts.append("") # dummy
	labels_texts.append("")
	labels_texts.append("")
	labels_texts.append("") # dummy
	
	face_sets.append(-1)
	face_sets.append(-1)
	face_sets.append(-1)
	face_sets.append(3)
	face_sets.append(0)
	face_sets.append(3)
	face_sets.append(1)
	face_sets.append(3)
	face_sets.append(2)
	face_sets.append(3)
	face_sets.append(-1) # dummy
	face_sets.append(-1)
	face_sets.append(-1)
	face_sets.append(-1) # dummy

func _ready():
	shake_amount = hyperspace.get_shake()
	sound_level = hyperspace.get_bgm_level()
	hyperspace.set_bgm_level(0)
	ship_flash_length = hyperspace.ship_flash_length
	setup_dialog()
	canvas.set_color(Color(0,0,0))
	set_process(true)
	set_process_input(true)
	
	
func _process(delta):
	if time_passed > initial_delay and sequence_started == false:
		continue_dialog()
		sequence_started = true
	time_passed += delta
	if not sequence_started:
		current_color_value = time_passed / initial_delay
		canvas.set_color(Color(current_color_value, current_color_value, current_color_value))
		hyperspace.set_bgm_level(current_color_value * sound_level)
		
	if time_passed < incident_delay and incident_started:
		current_color_value = time_passed / incident_delay
		hyperspace.set_shake(current_color_value * (target_shake -  shake_amount) + shake_amount)
		canvas.set_color(Color(1-current_color_value*2, 1-current_color_value, 1-current_color_value))
		hyperspace.set_bgm_level(1- (current_color_value * sound_level))
		rift_player.set_volume(sound_level * current_color_value)
		hyperspace.ship_flash_length = current_color_value*(incident_flash_length - ship_flash_length) + ship_flash_length
		#hyperspace.flash_length = hyperspace.flash_length + current_color_value*(incident_flash_length - ship_flash_length)
		
	elif time_passed > incident_delay and incident_started:
		continue_dialog()
		incident_started = false
	

func _on_StopButton_pressed():
	continue_dialog()


func continue_dialog():
	scene_idle = false
	continue_button.hide()
	dialog_position = dialog_position + 1;
	if dialog_position == 13: # end
		get_tree().change_scene(target_level)
	if face_sets[dialog_position] < 0:
		faceset.hide()
	else:
		faceset.show()
		faceset_frame.set_frame(face_sets[dialog_position])
		faceset_label.set_text(labels_texts[dialog_position])
	terminal.clear()
	
	if dialog_position == 10:
		incident_started = true
		rift_player.play(0)
		time_passed = 0
	else:
		terminal.start_writing(texts[dialog_position])

func _on_Terminal_text_finished():
	continue_button.show()
	scene_idle = true


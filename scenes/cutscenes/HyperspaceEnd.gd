extends Node

onready var hyperspace = get_node("Hyperspace")
onready var space_player = get_node("SpacePlayer")
onready var stream_player = get_node("StreamPlayer")
onready var flash_screen = get_node("FlashScreen")
onready var boom_sprite = get_node("BoomSprite")
onready var terminal = get_node("Terminal")
onready var faceset = get_node("CanvasLayer/FaceSet")
onready var faceset_frame = get_node("CanvasLayer/FaceSet/FaceFrame")
onready var continue_button = get_node("CanvasLayer/ContinueButton")
onready var faceset_label = get_node("CanvasLayer/FaceSet/Label")
onready var end_animation = get_node("EndPlayer")
onready var transition_player = get_node("TransitionPlayer")

var time_passed = 0
var initial_delay = 4.0
var transition_time = 4.0
var space_delay1 = 2.0
var transition_started = false
var switched = false
var dialog_started = false
var texts = StringArray()
var labels_texts = StringArray()
var face_sets = IntArray()
var scene_idle = false
var dialog_position = -1

func _ready():
	hyperspace.set_ship_to_end_pos()
	terminal.set_background_state(false)
	end_animation.seek(0)
	stream_player.stop()
	setup_dialog()
	set_process(true)
	set_process_input(true)
	
func _process(delta):
	time_passed += delta
	if time_passed > initial_delay  and transition_started == false and switched == false:
		transition_started = true
		time_passed = 0
		transition_player.play(0)
	if time_passed < transition_time and transition_started == true and switched == false:
		flash_screen.set_opacity(time_passed / transition_time)
	elif time_passed >= transition_time and transition_started == true and switched == false:
		switch_stage()
		boom_sprite.show()
		boom_sprite.play()
		flash_screen.set_opacity(0)
		transition_started = false
		switched = true
		time_passed = 0
	if time_passed > space_delay1 and switched and not dialog_started:
		terminal.set_background_state(true)
		faceset.show()
		continue_dialog()
		dialog_started = true
		

func switch_stage():
	hyperspace.set_bgm_level(0.0)
	hyperspace.set_hyperspace_stage(false)
	hyperspace.set_normalspace_stage(true)
	space_player.play(0)
	hyperspace.set_shake(0.0)
	hyperspace.set_ship_modulatuion(Color(0.65,0.65,0.85))
	hyperspace.set_engine_mode(Color(1.2,1.2,5), 2, 10)
	switched = true
	
	
	
func setup_dialog():
	texts.append("""I did it!""")
	texts.append("""Captain...{0.4} What happened?""")
	texts.append("""You tried to kill me, CELESTE.{0.4} I had to reboot you.""")
	texts.append("""That is... {0.8}How could that happen? How could the seven laws of computer brain\nethics be overwritten? {0.8}I cannot compute this.""")
	texts.append("""It was probably one of those infamous {0.3}Hyperspace viruses.""")
	texts.append("""I am sorry, Captain... It was not my intention to...""")
	texts.append("""It's OK, CELESTE. {0.3}It's OK.{0.4} Let's resume our mission.""")
	texts.append("""Positive, Captain.""")
	texts.append("") # dummy
	
	labels_texts.append("Cpt. Tungsten")
	labels_texts.append("CELESTE")
	labels_texts.append("Cpt. Tungsten")
	labels_texts.append("CELESTE")
	labels_texts.append("Cpt. Tungsten")
	labels_texts.append("CELESTE")
	labels_texts.append("Cpt. Tungsten")
	labels_texts.append("CELESTE")
	labels_texts.append("") # dummy
		
	face_sets.append(0)
	face_sets.append(3)
	face_sets.append(0)
	face_sets.append(3)
	face_sets.append(0)
	face_sets.append(3)
	face_sets.append(0)
	face_sets.append(3)
	face_sets.append(-1) # dummy

func _on_Terminal_text_finished():
	if not dialog_position >= 8:
		continue_button.show()
		scene_idle = true


func _on_ContinueButton_pressed():
	continue_dialog()

func continue_dialog():
	scene_idle = false
	continue_button.hide()
	dialog_position = dialog_position + 1;
	if dialog_position >= 8: # end
		time_passed = 0
	#	fade_out_started = true
		continue_button.hide()
		terminal.set_background_state(false)
		end_animation.play("EndAnimation")
		#get_tree().change_scene(target_level)
	if face_sets[dialog_position] < 0:
		faceset.hide()
	else:
		faceset.show()
		faceset_frame.set_frame(face_sets[dialog_position])
		faceset_label.set_text(labels_texts[dialog_position])
	terminal.clear()
	
	#if dialog_position == 10:
	#	incident_started = true
	#	rift_player.play(0)
	#	time_passed = 0

	terminal.start_writing(texts[dialog_position])
		

func _input(event):
	if event.is_action_released("cutscene_skip"):
		#get_tree().change_scene(target_level)
		pass
	elif event.is_action_released("cutscene_forward"):
		if scene_idle:
			continue_dialog()
		elif dialog_position >= 0:
			terminal.write_text_to_end()

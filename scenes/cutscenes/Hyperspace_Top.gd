extends Node

onready var animation_player = get_node("AnimationPlayer")
onready var terminal = get_node("Terminal")
onready var faceset = get_node("CanvasLayer/FaceSet")
onready var faceset_frame = get_node("CanvasLayer/FaceSet/FaceFrame")
onready var continue_button = get_node("CanvasLayer/ContinueButton")
onready var faceset_label = get_node("CanvasLayer/FaceSet/Label")

#var last_pos
var time_passed = 0.0
var sequence_started = false
var dialog_position = -1

var initial_delay = 3.0
var texts = StringArray()
var labels_texts = StringArray()
var face_sets = IntArray()

func setup_dialog():
	var elements = 10
	#texts.resize(elements)
	
	texts.append("""2023 AD - Beta Hyperspace{0.8}\nThe interstellar carrier ''IHS Renegade'' is on the way to the ice moon Ilex in\nthe far-off Hibris system with an important cargo of Baranium Sulfide,\ndedicated to the Hyper-Mines of this inhospitable colony of mankind.""")
	texts.append("""Mission:{0.4}\nHyperspace carriage (Batch: BTS-SHD-788-B2S4){0.4}\nClient - Beyond the Skies (BTS), Xin-Shanghai{0.4}\nDestination - Ilex, Hibris (G3S479-P3-M7){0.4}""")
	texts.append("""Crew:{0.4}\nCpt. Wolfram Tungsten {0.4}[Human]{0.4}\nCELESTE {0.4}[Autonomous Electronic Brain]""")
	texts.append("""Captain, my sensors are detecting an anomaly""")
	texts.append("""What is it, CELESTE?""")
	texts.append("""I don’t know yet. It looks like a distortion in the Beta Hyperspace.""")
	texts.append("""That’s impossible!""")
	texts.append("""Hold on for a second…{0.8}\nWarning! I detected a hyperspace rift 1000 miles ahead!""")
	texts.append("""What!? CELESTE, sidestep!""")
	texts.append("""Too late...""")

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

	#face_sets.resize(elements)
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

func _ready():
	setup_dialog()
	#animation_player.play("TopAnimation")
	set_process(true)
	
func _process(delta):
	if time_passed > initial_delay and sequence_started == false:
		continue_dialog()
		sequence_started = true
	time_passed += delta
	
	
#func pause_text():
#	last_pos = animation_player.get_pos()
#	animation_player.stop(false);

func _on_StopButton_pressed():
	continue_dialog()
#	terminal.clear()
#	animation_player.play()
#	animation_player.seek(last_pos, true)

func continue_dialog():
	continue_button.hide()
	dialog_position = dialog_position + 1;
	if face_sets[dialog_position] < 0:
		faceset.hide()
	else:
		faceset.show()
		faceset_frame.set_frame(face_sets[dialog_position])
		faceset_label.set_text(labels_texts[dialog_position])
	terminal.clear()
	terminal.start_writing(texts[dialog_position])
	#get_node("CanvasLayer/StopButton").show()

func _on_Terminal_text_finished():
	continue_button.show()
	#get_node("CanvasLayer/StopButton").show()
	#pause_text()
	pass # replace with function body

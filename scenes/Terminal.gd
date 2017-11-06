tool

extends Panel

onready var label = get_node("RichTextLabel")
onready var sample_player = get_node("SamplePlayer2D") 
#var sounds = ["key_1", "key_2", "key_3", "key_4", "key_5"] 
var sounds = ["blip1"] 

export(int) var maximum_lines = 36
export(int) var time_between_keystrokes = 0.08

var lines = []
var lines_string = ""

var is_writing = false
var text = ""
var time_since_last_keystroke = 0


func _init():
	pass
	
func _ready():
	HUD.toggle_hide()
	set_process(true)
	
	start_writing(
	"You   can use the shader by just copying the CRTDisplayShader.shd to your project\n" +
	"(it's the Shader raw code). But if you don't know how to setup the shader material,\n" +
	"you can just use the CRTViewportDisplay:")

func _process(delta):
	time_since_last_keystroke += delta
	if is_writing:
		if time_since_last_keystroke >= time_between_keystrokes:
			time_since_last_keystroke = 0
			if text.length() > 0:
				var character = text[0]
			label.set_text(label.get_text() + text[0])
			text = text.right(1).left(text.length())
			play_sound()
			
func start_writing(text):
	self.text = text
	self.is_writing = true
	
func stop_writing():
	self.is_writing = false

func play_sound():
	var sound = sounds[rand_range(0, sounds.size())-1]
	sample_player.play(sound)
	sample_player.stop_all()
	
func write_new_line(new_line):
	new_line = str(new_line)
	# Delete last log entry if log too long
	if lines.size() >= maximum_lines:
		lines.pop_front()
	
	lines.push_back(new_line)
	
	lines_string = ""
	for line in lines:
		lines_string += line + "\n"
	label.set_text(lines_string + "█")
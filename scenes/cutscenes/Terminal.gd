extends CanvasLayer

onready var background = get_node("Background")
onready var label = get_node("RichTextLabel")
onready var sample_player = get_node("SamplePlayer")
onready var CRT = get_node("CRT")
var fallback_sound = "blip1" 

export(int) var maximum_lines = 36
export(float) var time_between_keystrokes = 0.05
export(StringArray) var sounds
export(bool) var show_background = true
export(String, MULTILINE) var message = "le zomgue" 
export(bool) var controlled_by_script = false

signal text_finished	

var lines = []
var lines_string = ""

var is_writing = false
var text = ""
var time_since_last_keystroke = 0

var delay_regex
var end_signal_sent = false

func _init(): 
	delay_regex = RegEx.new()
	delay_regex.compile("^{(\\d*\\.?\\d*?)}(.*)")	
	
func _ready():	
	if sounds != null or sounds.size() == 0:
		sounds = StringArray([fallback_sound])
		
	if show_background:
		background.show()
	else:
		background.hide()
		
	set_process(true)
	if not controlled_by_script:
		start_writing(message)
	
	#"""2023 AD – Beta Hyperspace{0.4}\nThe interstellar carrier “IHS  North Star” is on the way to the ice moon Ilex in the far-off Hibris system with an important cargo of Baranium Sulfide, dedicated to the Hyper-Mines of Ilex.""")

func _process(delta):
	time_since_last_keystroke += delta
	if is_writing:
		if time_since_last_keystroke >= time_between_keystrokes:
			time_since_last_keystroke = 0
			if text.length() > 0:
				# Pause
				var delay_pos = delay_regex.find(text)
				if delay_pos == 0:
					var delay = delay_regex.get_capture(1)
					time_since_last_keystroke -= float(delay)
					text = delay_regex.get_capture(2)
				else:					
					var character = text[0]
					label.set_text(label.get_text() + text[0])
					if not text[0] == " ":
						play_sound()
					text = text.right(1).left(text.length())
			else:
				send_end_signal()

func send_end_signal():
	if not end_signal_sent:
		emit_signal("text_finished")
		end_signal_sent = true

func start_writing(text):
 self.end_signal_sent = false
 self.text = text
 self.is_writing = true
 

func stop_writing():
 self.is_writing = false

func clear():
	stop_writing()
	label.clear()
	self.text = ""

func play_sound():
 var sound = sounds[rand_range(0, sounds.size())-1]
 #sample_player.play(sound)
 sample_player.play(sound)
 #sample_player.stop_all()
 
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

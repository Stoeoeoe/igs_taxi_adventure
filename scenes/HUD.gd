extends CanvasLayer

onready var log_entries_label = get_node("RootControl/LogEntries")
onready var score_label = get_node("RootControl/ScoreLabel")

var log_entries = []
var log_string = ""
export(int) var maximum_lines = 3

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	log_entries_label.set_text("Hyper Kernel v. 0.96 loaded!")
	pass

func out(new_log_entry):
	new_log_entry = str(new_log_entry)
	# Delete last log entry if log too long
	if log_entries.size() >= maximum_lines:
		log_entries.pop_front()
	
	log_entries.push_back(new_log_entry)
	
	log_string = ""
	for entry in log_entries:
		log_string += entry + "\n"
	log_entries_label.set_text(log_string)
	
func toggle_hide():
	get_node("RootControl").set_hidden(get_node("RootControl").is_visible())
	
func set_score(score):
	score_label.set_text(str(score))
	
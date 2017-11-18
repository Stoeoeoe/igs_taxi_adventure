extends CanvasLayer

onready var log_entries_label = get_node("RootControl/LogEntries")
onready var score_label = get_node("RootControl/ScoreLabel")

export(Texture) var life_texture = preload("res://assets/imgs/life.png")

var log_entries = []
var log_string = ""
export(int) var maximum_lines = 3

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	log_entries_label.set_text("Hyper Kernel v. 0.96 loaded!")
	pass

func write(new_log_entry):
	new_log_entry = str(new_log_entry)
	# Delete last log entry if log too long
	if log_entries.size() >= maximum_lines:
		log_entries.pop_front()
	
	log_entries.push_back(new_log_entry)
	
	log_string = ""
	for entry in log_entries:
		log_string += entry + "\n"
	log_entries_label.set_text(log_string)

func add_life():
	var life_texture_frame = TextureFrame.new()
	life_texture_frame.set_texture(life_texture)
	life_texture_frame.set_size(life_texture.get_size())
	get_node("RootControl/LifeBox").add_child(life_texture_frame)
	
func remove_life():
	var first_child = get_node("RootControl/LifeBox").get_child(0)
	get_node("RootControl/LifeBox").remove_child(first_child)
	
func show_hud():
	get_node("RootControl").set_hidden(false)
	
func toggle_hide():
	get_node("RootControl").set_hidden(get_node("RootControl").is_visible())

func hide_hud():
	get_node("RootControl").set_hidden(true)	
			
func set_score(score):
	score_label.set_text(str(score))
	
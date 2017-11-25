extends Panel

onready var stream_player = get_node("CentralStreamPlayer")
onready var light_container = get_node("BlinkenLights")
onready var animation_player = get_node("AnimationPlayer")

var level_selection_bubbles = []
var bubble_original_positions = []
var max_floating = 20
var lights
var lights_active = IntArray()
var lights_time_to_wait  = FloatArray()
var design_time = false

func _ready():
	level_selection_bubbles = get_tree().get_nodes_in_group("level_selection_bubble")
	level_selection_bubbles.sort_custom(self, "sort_bubbles")
	lights = light_container.get_children()
	lights_active.resize(lights.size())
	lights_time_to_wait.resize(lights.size())
	for i in range(lights.size()):
		lights_active[i] = 0
	animation_player.play("TextAnimation")
	set_process(true)
	
	for bubble in level_selection_bubbles:
		bubble.connect("level_selected", self, "select_level", [])
		bubble.connect("level_selected_failed", self, "select_level_failed", [])
		bubble_original_positions.append(bubble.get_pos())
	
	get_node("Lines").level_selection_bubbles = level_selection_bubbles
	#set_process(true)
	
func _process(delta):
	
	handle_blinken_lights(delta)
	if design_time:
		var i = 0
		for bubble in level_selection_bubbles:
			var pos = bubble.get_pos()
			var x_movement = round(rand_range(-1, 1))
			var y_movement  = round(rand_range(-1, 1))
			var new_x = pos.x + x_movement
			var new_y = pos.y + y_movement
			if not (abs(pos.x - bubble_original_positions[i].x) > max_floating):
				pos.x = new_x
			if not (abs(pos.y - bubble_original_positions[i].y) > max_floating):
				pos.y = new_y
				
			bubble.set_pos(pos)
			i += 1
				
func sort_bubbles(first_element, second_element):
	return true if first_element.level < second_element.level else false

func select_level(level):
	get_tree().change_scene("res://scenes/levels/Level" + str(level) + ".tscn")

func select_level_failed(level):
	get_node("IGSCamera").shake(0.2, 5)
	
func play_music():
	stream_player.play()
	
func stop_music():
	stream_player.stop()
	
func handle_blinken_lights(delta):
	for i in range(lights.size()):
		if lights_active[i] == 1:
			lights_time_to_wait[i] -= delta
			if lights_time_to_wait[i] < 0:
				lights[i].hide()
				lights_active[i] = 0
	for j in range(lights.size()):
		if lights_active[j] == 0:
			if randi() % 75 == 0:
				lights_active[j] = 1
				lights[j].show()
				lights_time_to_wait[j] = rand_range(1,5)
	#ligts = light_container.get_children()
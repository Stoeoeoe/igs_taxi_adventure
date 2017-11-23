extends Panel

onready var stream_player = get_node("CentralStreamPlayer")

var level_selection_bubbles = []
var bubble_original_positions = []
var max_floating = 20

func _ready():
	level_selection_bubbles = get_tree().get_nodes_in_group("level_selection_bubble")
	level_selection_bubbles.sort_custom(self, "sort_bubbles")
	
	for bubble in level_selection_bubbles:
		bubble.connect("level_selected", self, "select_level", [])
		bubble.connect("level_selected_failed", self, "select_level_failed", [])
		bubble_original_positions.append(bubble.get_pos())
	
	get_node("Lines").level_selection_bubbles = level_selection_bubbles
	#set_process(true)
	
func _process(delta):
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
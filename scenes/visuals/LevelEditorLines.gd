extends Node2D

var level_selection_bubbles

func _draw():
	var i = 0
	var total_bubbles = level_selection_bubbles.size()
	for bubble in level_selection_bubbles:
		if i < total_bubbles -1:
			var next_bubble = level_selection_bubbles[i+1]
			var pos_1 = bubble.get_pos() + bubble.texture_frame.get_size() / 2
			var pos_2 = next_bubble.get_pos() + next_bubble.texture_frame.get_size() / 2
			
			draw_line(pos_1, pos_2, Color(0.419, 0.937, 0.286), 5)
			draw_line(pos_1 - Vector2(2,2), pos_2, Color(0.419, 0.937, 0.286, 0.15), 5)
			draw_line(pos_1 - Vector2(1,1), pos_2, Color(0.419, 0.937, 0.286, 0.25), 5)
			draw_line(pos_1 + Vector2(1,1), pos_2, Color(0.419, 0.937, 0.286, 0.25), 5)
			draw_line(pos_1 + Vector2(2,2), pos_2, Color(0.419, 0.937, 0.286, 0.15), 5)
			i+=1
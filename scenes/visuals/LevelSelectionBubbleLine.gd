extends Node2D

var level_selection_bubbles
var aa_color = Color(1,1,1,0)


func _draw():
	var i = 0
	var total_bubbles = level_selection_bubbles.size()
	for bubble in level_selection_bubbles:
		if i < total_bubbles -1:
			var next_bubble = level_selection_bubbles[i+1]
			var pos_1 = bubble.get_pos() + bubble.texture_frame.get_size() / 2
			var pos_2 = next_bubble.get_pos() + next_bubble.texture_frame.get_size() / 2
			
			var color
			if next_bubble.status == "LOCKED":
				color = Color(0.8, 0.1, 0.1, 1)
			else:
				color = Color(0.419, 0.937, 0.286)
				
			draw_line(pos_1, pos_2, color, 5)
			draw_line(pos_1 - Vector2(2,2), pos_2, color.linear_interpolate(aa_color,0.15), 5)
			draw_line(pos_1 - Vector2(1,1), pos_2, color.linear_interpolate(aa_color,0.25), 5)
			draw_line(pos_1 + Vector2(1,1), pos_2, color.linear_interpolate(aa_color,0.25), 5)
			draw_line(pos_1 + Vector2(2,2), pos_2, color.linear_interpolate(aa_color,0.15), 5)
			i+=1
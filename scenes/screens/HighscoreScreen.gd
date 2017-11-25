extends Panel

signal menu_closed

var highscore_line_class = preload("res://scenes/screens/HighscoreLine.tscn")

func _ready():
	HUD.hide_gameoverlay()
	var highscores = get_highscores()
	for highscore_entry in highscores:
		var line = highscore_line_class.instance()
		line.set_entry(highscore_entry.rank, highscore_entry.name, highscore_entry.score)
		get_node("HighscoreBox/LineBox").add_child(line)
		
func get_highscores():
	var highscores_dictionary = []
	var number_entries = 20
	for i in range(1, 10):
		var entry = {}
		entry["rank"] = i
		entry["name"] = "Heiri"
		entry["score"] = (number_entries - i) * 213
		highscores_dictionary.append(entry)
	pass
	return highscores_dictionary

func _on_CloseButton_pressed():
	emit_signal("menu_closed")

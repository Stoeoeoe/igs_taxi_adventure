extends Control

var unlocked_levels = []

func _ready():
	var level_selection_bubbles = get_tree().get_nodes_in_group("level_selection_bubble")
	for bubble in level_selection_bubbles:
		bubble.connect("level_selected", self, "select_level", [])
		bubble.connect("level_selected_failed", self, "select_level_failed", [])

func select_level(level):
	get_tree().change_scene("res://scenes/levels/Level" + str(level) + ".tscn")

func select_level_failed(level):
	get_node("IGSCamera").shake(0.2, 5)

func _on_ExitButton_pressed():
	get_tree().quit()


func _on_CreditsAndLicensesButton_pressed():
	pass # replace with function body


func _on_HighscoreButton_pressed():
	pass # replace with function body


func _on_SettingsButton_pressed():
	get_node("MainMenu").hide()
	get_node("SettingsMenu").show()


func _on_StartButton_pressed():
	pass # replace with function body


func _on_SaveChangesButton_pressed():
	var crt = get_node("SettingsMenu/GridContainer/HBoxContainer/CRTEffect")
	
	get_node("MainMenu").show()
	get_node("SettingsMenu").hide()	


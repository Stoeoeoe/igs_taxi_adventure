extends Control

var unlocked_levels = []
onready var settings_menu = get_node("SettingsMenu")
onready var main_menu = get_node("MainMenu")
onready var level_menu = get_node("LevelMenu")

func _ready():
	pass
	


func _on_ExitButton_pressed():
	get_tree().quit()


func _on_CreditsAndLicensesButton_pressed():
	pass # replace with function body


func _on_HighscoreButton_pressed():
	pass # replace with function body


func _on_SettingsButton_pressed():
	main_menu.hide()
	settings_menu.show()



func _on_StartButton_pressed():
	main_menu.hide()
	level_menu.show()
	


func _on_SaveChangesButton_pressed():
	var crt = get_node("SettingsMenu/GridContainer/HBoxContainer/CRTEffect")
	main_menu.show()
	settings_menu.hide()	


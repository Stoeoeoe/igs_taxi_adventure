extends Control

var unlocked_levels = []
onready var settings_menu = get_node("SettingsMenu")
onready var main_menu = get_node("MainMenu")
onready var level_menu = get_node("LevelMenu")
onready var animation = get_node("AnimationPlayer")

func _ready():
	HUD.hide_hud()
	if animation != null:
		animation.play("TitleAnimation")
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
	

func _on_BackToMainMenuButton_button_down():
	level_menu.hide()
	settings_menu.hide()
	main_menu.show()
	


func _on_DiscardChangesButton_pressed():
	settings_menu.hide()
	main_menu.show()

extends Control

onready var animation_player = get_node("AnimationPlayer")

var unlocked_levels = []

signal menu_selected(menu)
signal back_button_pressed

func _ready():
	animation_player.play("ShinyAnimation")


func _on_StartButton_pressed():
	emit_signal("menu_selected", "save_the_universe")


func _on_CreditsAndLicensesButton_pressed():
	emit_signal("menu_selected", "credits_and_licenses")


func _on_HighscoreButton_pressed():
	emit_signal("menu_selected", "high_score")


func _on_SettingsButton_pressed():
	emit_signal("menu_selected", "settings")


func _on_BackToMainMenuButton_button_down():
	emit_signal("back_button_pressed")

func _on_ExitButton_pressed():
	get_tree().quit()

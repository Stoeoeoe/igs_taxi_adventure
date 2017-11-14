extends Control

func _ready():
	pass



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
	get_node("MainMenu").show()
	get_node("SettingsMenu").hide()	

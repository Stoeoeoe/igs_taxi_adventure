extends Panel

func _ready():
	pass

func _on_SaveChangesButton_pressed():
	Settings.update_config("visuals", "crt", get_node("GridContainer/CRTEffect").is_pressed())
	Settings.update_config("visuals", "crt_strength", get_node("GridContainer/CRTStrength").get_value())
#	Settings.update_config("audio", "music_volume", get_node("GridContainer/CRTStrength").get_value())
#	Settings.update_config("audio", "sfx_volume", get_node("GridContainer/CRTStrength").get_value())
	
	get_parent().main_menu.show()
	self.hide()	


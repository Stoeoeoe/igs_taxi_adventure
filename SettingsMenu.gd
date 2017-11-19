extends Panel

onready var crt_effect_enabled = get_node("GridContainer/CRTEffectEnabled")
onready var crt_scanline_opacity = get_node("GridContainer/CRTScanlineOpacity")
onready var crt_color_bleeding = get_node("GridContainer/CRTColorBleeding")

func _ready():
	crt_effect_enabled.connect("toggled", Settings, "update_settings", ["visuals", "crt_enabled"])
	crt_scanline_opacity.connect("value_changed", Settings, "update_settings", ["visuals", "crt_scanline_opacity"])
	crt_color_bleeding.connect("value_changed", Settings, "update_settings", ["visuals", "crt_color_bleeding"])
	

func _on_SaveChangesButton_pressed():
	# TODO
	var original_values = {}
	
	Settings.update_settings(crt_effect_enabled.is_pressed(), "visuals", "crt_enabled")
	Settings.update_settings(crt_scanline_opacity.get_value(), "visuals", "crt_scanline_opacity" )
	Settings.update_settings(crt_color_bleeding.get_value(), "visuals", "crt_color_bleeding")
#	Settings.update_config("audio", "music_volume", get_node("GridContainer/CRTStrength").get_value())
#	Settings.update_config("audio", "sfx_volume", get_node("GridContainer/CRTStrength").get_value())
	Settings.save_config()
	

	get_parent().main_menu.show()
	self.hide()	
	
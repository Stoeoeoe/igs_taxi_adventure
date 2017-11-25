extends Panel

onready var crt_effect_enabled = get_node("SettingsBox/GridContainer/CRTEffectEnabled")
onready var crt_scanline_opacity = get_node("SettingsBox/GridContainer/CRTScanlineOpacity")
onready var crt_color_bleeding = get_node("SettingsBox/GridContainer/CRTColorBleeding")
onready var crt_color_bleeding_distance = get_node("SettingsBox/GridContainer/CRTColorBleedingDistance")
onready var sfx_volume = get_node("SettingsBox/GridContainer/SFXVolume")
onready var music_volume = get_node("SettingsBox/GridContainer/MusicVolume")

signal menu_closed

func _ready():
	set_values_from_settings()
	crt_effect_enabled.connect("toggled", Settings, "update_settings", ["visuals", "crt_enabled"])
	crt_scanline_opacity.connect("value_changed", Settings, "update_settings", ["visuals", "crt_scanline_opacity"])
	crt_color_bleeding.connect("value_changed", Settings, "update_settings", ["visuals", "crt_color_bleeding"])
	crt_color_bleeding_distance.connect("value_changed", Settings, "update_settings", ["visuals", "crt_color_bleeding_distance"])
	sfx_volume.connect("value_changed", Settings, "update_settings", ["sound", "sfx_volume"])
	music_volume.connect("value_changed", Settings, "update_settings", ["sound", "music_volume"])
	
func set_values_from_settings():
	crt_effect_enabled.set_pressed(Settings.visuals_crt_enabled)
	crt_scanline_opacity.set_value(Settings.visuals_crt_scanline_opacity)
	crt_color_bleeding.set_value(Settings.visuals_color_bleeding)
	crt_color_bleeding_distance.set_value(Settings.visuals_crt_color_bleeding_distance)
	sfx_volume.set_value(Settings.sound_sfx_volume)
	music_volume.set_value(Settings.sound_music_volume)
	
func _on_SFXVolume_input_event(event):
	if event.type == InputEvent.MOUSE_BUTTON and not event.pressed:
		get_node("../CentralSamplePlayer").play("select_menu")
	
func _on_SaveChangesButton_pressed():
	# TODO
	var original_values = {}
	
	Settings.update_settings(crt_effect_enabled.is_pressed(), "visuals", "crt_enabled")
	Settings.update_settings(crt_scanline_opacity.get_value(), "visuals", "crt_scanline_opacity" )
	Settings.update_settings(crt_color_bleeding.get_value(), "visuals", "crt_color_bleeding")
	Settings.update_settings(crt_color_bleeding_distance.get_value(), "visuals", "crt_color_bleeding_distance")
	Settings.update_settings(crt_color_bleeding_distance.get_value(), "visuals", "crt_color_bleeding_distance")
	
			#	Settings.update_config("audio", "music_volume", get_node("GridContainer/CRTStrength").get_value())
#	Settings.update_config("audio", "sfx_volume", get_node("GridContainer/CRTStrength").get_value())
	Settings.save_config()
	emit_signal("menu_closed")
	
func _on_DiscardChangesButton_pressed():
	Settings.read_config()
	set_values_from_settings()
	emit_signal("menu_closed")

func _on_SettingsMenu_visibility_changed():
	if is_visible():
		get_node("SettingsBox/GridContainer/CRTEffectEnabled").grab_focus()
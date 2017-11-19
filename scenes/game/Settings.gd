extends Node

const CONFIG_LOCATION = "res://game_settings.cfg"

# Settings
var visuals_crt_enabled = true
var visuals_crt_scanline_opacity = 1.0
var visuals_crt_color_bleeding = 2.0
var visuals_crt_color_bleeding_distance = 1.0
var visuals_color_bleeding = 0.0
var sound_sfx_volume = 1.0
var sound_music_volume = 1.0

signal config_updated(section, key, old_value, new_value)

func _ready():
	read_config()

func read_config():
	var config = ConfigFile.new()
	var err = config.load(CONFIG_LOCATION)
	if err == OK:
		for section in config.get_sections():
			for key in config.get_section_keys(section):
				var property_name = section + "_" +  key
				var default_value = get(property_name)
				var value = config.get_value(section, key, default_value)
				set(section + "_" +  key, value)
	pass
	
func update_settings(new_value, section, key):
	var old_value = get(section + "_" +  key)
	set(section + "_" +  key, new_value)
	emit_signal("config_updated", section, key, old_value, new_value)
	
func save_config():
	var config = ConfigFile.new()
	var err = config.load(CONFIG_LOCATION)
	if err == OK:
		for section in config.get_sections():
			for key in config.get_section_keys(section):
				var property_name = section + "_" +  key
				var default_value = get(property_name)
				var value = config.get_value(section, key, default_value)
				config.set_value(section, key, value)

	
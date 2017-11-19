extends Node

const CONFIG_LOCATION = "res://game_settings.cfg"

# Settings
var visuals_crt_enabled = true
var visuals_crt_strength = 1.0
var visuals_color_bleeding = 0.0
var sound_sfx_volume = 1.0
var sound_music_volume = 1.0

signal config_updated(section, key)

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
				var code = set(section + "_" +  key, value)
				print(code)
	pass
	
func update_config(section, key, value):
	var config = ConfigFile.new()
	var err = config.load(CONFIG_LOCATION)
	if err == OK:
		config.set_value(section, key, value)
		set(section + "_" +  key, config.get_value(section, key, get(section + "_" +  key)))
		config.save(CONFIG_LOCATION)
	emit_signal("config_updated", section, key)
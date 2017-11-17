extends Node

const CONFIG_LOCATION = "user://game_settings.cfg"

# Settings
var crt = false

static func read_config():
	var config = ConfigFile.new()
	var err = config.load(CONFIG_LOCATION)
	if err == OK:
		for section in config.get_sections():
			for key in config.get_section_keys():
				var default_value = get(key)
				Globals.set("settings." + section + "." +  key, config.get_value(section, key, default_value))
	
	
static func update_config(group, key, value):
	var config = ConfigFile.new()
	var err = config.load(CONFIG_LOCATION)
	if err == OK:
		config.set_value(group, key, value)
		Globals.set("settings." + group + "." + key, value)
		config.save(CONFIG_LOCATION)
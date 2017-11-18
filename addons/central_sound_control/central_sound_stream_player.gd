tool
extends StreamPlayer

var music_variable = ""
var volume = 1

func _ready():
#	var config = ConfigFile.new()
#	config.load("plugin.cfg")
#	music_variable = config.get_value("custom", "global_music_variable_name", "settings.sound.music")
	var volume = Settings.sound_music_volume
	set_volume(volume)
	Settings.connect("config_updated", self, "check_if_volume_must_be_changed", [])
	
func check_if_volume_must_be_changed(section, key):
	if section == "sound" and key  == "music_volume":
		set_volume(Settings.sound_music_volume)
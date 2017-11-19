tool
extends StreamPlayer

var music_variable = ""
var volume = 1

func _ready():
	Settings.connect("config_updated", self, "check_if_volume_must_be_changed", [])
	set_volume(Settings.sound_music_volume)

	
func check_if_volume_must_be_changed(section, key, old_value, new_value):
	if section == "sound" and key  == "music_volume":
		set_volume(Settings.sound_music_volume)
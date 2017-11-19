tool
extends SamplePlayer

var sfx_variable = ""
var volume = 1

func _ready():
	Settings.connect("config_updated", self, "check_if_volume_must_be_changed", [])
	set_default_volume(Settings.sound_sfx_volume)

	
func check_if_volume_must_be_changed(section, key, old_value, new_value):
	if section == "sound" and key  == "sfx_volume":
		set_default_volume(Settings.sound_sfx_volume)
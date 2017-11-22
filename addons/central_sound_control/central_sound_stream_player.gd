
extends StreamPlayer

var music_variable = ""
var volume = 1
var db_overwrite = 0
export(bool) var is_sfx = false 

func _ready():
	Settings.connect("config_updated", self, "check_if_volume_must_be_changed", [])
	if is_sfx:
		set_volume(Settings.sound_sfx_volume)
	else:
		set_volume(Settings.sound_music_volume)		

	
func check_if_volume_must_be_changed(section, key, old_value, new_value):
	if section == "sound":
		if key  == "music_volume" and not is_sfx: 
			set_volume(Settings.sound_music_volume)
		if key  == "sfx_volume" and is_sfx: 
			set_volume(Settings.sound_sfx_volume)

		
		
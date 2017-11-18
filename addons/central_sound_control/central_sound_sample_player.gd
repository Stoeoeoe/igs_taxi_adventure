tool
extends SamplePlayer

var sfx_variable = ""
var volume = 1

func _ready():
	var config = ConfigFile.new()
	config.load("plugin.cfg")
	sfx_variable = config.get_value("custom", "global_sfx_variable_name", "settings.sound.sfx")

func play(name, unique = false):
	volume = Globals.get(sfx_variable)
	#set_default_volume(volume)
	#play(name, unique)
extends TextureFrame

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	var has_crt_effect = Globals.get("settings.visual.has_crt_effect")
	var crt_strength = Globals.get("settings.visual.crt_strenth")
	
	if not has_crt_effect:
		hide()
	else:
		show()
	
	self.set_opacity(crt_strength)
extends TextureFrame

var show_crt_effect = true
var crt_strength = 1.0
var initial_crt_alpha = 1.0

func _ready():
	initial_crt_alpha = get_material().get_shader_param("scanline_alpha")
	Settings.connect("settings_changed", self, "check_if_crt_settings_changed", [])
	show_crt_effect = Settings.visuals_crt
	crt_strength = Settings.visuals_crt_strength
	update_crt_effect()
		
func check_if_crt_settings_changed(section, key):
	if section == "visual" and key == "crt":
		show_crt_effect = Settings.visual_crt
		update_crt_effect()
	elif section == "visual" and key == "crt_strength":
		crt_strength = Settings.visual_crt_strength
		update_crt_effect()
		
func update_crt_effect():
	if show_crt_effect:
		show()
	else: 
		hide()
	var transparency = 1-(1-initial_crt_alpha)*crt_strength
	
	get_material().set_shader_param("scanline_alpha", transparency)
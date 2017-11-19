extends TextureFrame

var initial_crt_alpha = 1.0
export (int, "SETTINGS", "ON", "OFF") var control_override = 0

func _ready():
	initial_crt_alpha = get_material().get_shader_param("scanline_alpha")
	Settings.connect("config_updated", self, "check_if_crt_update_necessary", [])
	update_crt()

func check_if_crt_update_necessary(section, key):
	if section == "visual" and "crt_" in key:
		update_crt()

func update_crt():
	if Settings.visuals_crt_enabled:
		show()
	else: 
		hide()
	var transparency = 1-(1-initial_crt_alpha)*Settings.visuals_crt_strength
	get_material().set_shader_param("scanline_alpha", transparency)
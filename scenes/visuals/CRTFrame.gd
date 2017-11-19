extends TextureFrame

var initial_crt_scanline_alpha = 1
var initial_crt_color_bleeding = 0.4
export (String, "SETTINGS", "ON", "OFF") var crt_behavior = "SETTINGS" setget set_crt_behavior


func _ready():
	initial_crt_scanline_alpha = get_material().get_shader_param("scanline_alpha")
	initial_crt_color_bleeding = get_material().get_shader_param("color_bleeding")
	Settings.connect("config_updated", self, "check_if_crt_update_necessary", [])
	update_crt()

func set_crt_behavior(new_crt_behavior):
	crt_behavior = new_crt_behavior
	update_crt()

func check_if_crt_update_necessary(section, key, old_value, new_value):
	if section == "visuals" and "crt_" in key:
		update_crt()

func update_crt():
	if (Settings.visuals_crt_enabled and crt_behavior == "SETTINGS") or crt_behavior == "ON":
		show()
	else:
		hide()
	var transparency = 1-(1-initial_crt_scanline_alpha)*Settings.visuals_crt_scanline_opacity
	var color_bleeding = Settings.visuals_crt_color_bleeding
	get_material().set_shader_param("scanline_alpha", transparency)
	get_material().set_shader_param("color_bleeding", color_bleeding)
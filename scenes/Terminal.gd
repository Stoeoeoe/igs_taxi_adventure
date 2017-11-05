tool

extends Panel

export(Color) var bg_color setget set_bg_color, get_bg_color
export(Color) var font_color = Color("FF46CA42")

func _init():
	pass
	
	
func _ready():
	# https://github.com/godotengine/godot/blob/2.1/scene/resources/default_theme/default_theme.cpp
	var theme = Theme.new()
	var style_box = StyleBoxFlat.new()
	var dark_bg_color = bg_color.linear_interpolate("ffffffff", 0.2)
	var light_bg_color = bg_color.linear_interpolate("00000000", 0.2)
	style_box.set_bg_color(bg_color)
	style_box.set_dark_color(dark_bg_color)
	style_box.set_light_color(light_bg_color)

	theme.set_color("font_color", "Label", font_color)
	theme.set_stylebox("panel", "Panel", style_box)
	self.set_theme(theme)
#	theme.set_color("font_color_pressed", font_color)
#	var flat_stylebox = StyleBoxFlat.new()
#	self.add_style_override("panel", flat_stylebox)
	pass
	
func get_bg_color():
	return bg_color
	
func set_bg_color(new_bg_color):
	bg_color = new_bg_color
#	var color = rand_range(0, 255)
#	self.get_stylebox("panel").set_bg_color(Color(color, color, color))
	
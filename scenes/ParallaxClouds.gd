#tool
extends Node2D

export(int, 0, 9999) var speed = 20
export(Texture) var image = preload("res://assets/imgs/clouds1.png")
export(String, "RIGHT", "LEFT") var movement_direction = "RIGHT"
export(Color) var color = Color(1,1,1)
export(int, 0, 9999) var padding = 0

export(Color) var placerholder_color = Color(0,0,0) setget set_placeholder_color

var direction = 1
var screen_width = 0
var number_of_elements = 0
var texture_width = 0

func set_placeholder_color(color):
	placerholder_color = color
	get_node("Placeholder").set_modulate(placerholder_color)

func _ready():
	get_node("Placeholder").queue_free()
	texture_width = image.get_width()
	screen_width = OS.get_window_size().width
	number_of_elements = ceil(screen_width / texture_width) + 1
	
	direction = 1 if movement_direction == "RIGHT" else -1
	
	for i in range(0, number_of_elements):
		var sprite = Sprite.new()
		sprite.set_pos(Vector2(i * (texture_width + padding), 0))
		sprite.set_texture(image)
		sprite.set_modulate(color)
		add_child(sprite)
	
	
	HUD.toggle_hide()
	set_process(true)


func _process(delta):
	var number_of_pixels_moved = ceil(delta * speed * direction)
	for child in get_children():
		if child extends Sprite:
			var old_position = child.get_pos()

			var new_position
			if old_position.x >= screen_width + texture_width + padding and movement_direction == "RIGHT":
				new_position = Vector2(old_position.x - number_of_elements * (texture_width + padding) + number_of_pixels_moved, old_position.y)
			elif old_position.x <= 0 - texture_width - padding and movement_direction == "LEFT":
				new_position = Vector2(old_position.x + number_of_elements * (texture_width - padding) - number_of_pixels_moved, old_position.y)				
			else:
				new_position = old_position + Vector2(number_of_pixels_moved, old_position.y)
			child.set_pos(new_position)
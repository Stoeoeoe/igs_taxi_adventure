tool
extends Node2D

export(float) var speed = 20.0 setget set_speed
export(Texture) var image = preload("res://assets/imgs/cutscenes/clouds1.png") setget set_image
export(String, "RIGHT", "LEFT") var movement_direction = "RIGHT" setget set_movement_direction
export(Color) var color = Color(1,1,1) setget set_color
export(int, 0, 9999) var padding = 0 setget set_padding
export(Vector2) var scale = Vector2(1,1) setget set_scale




var direction = 1
var screen_width = 0
var number_of_elements = 0
var texture_width = 0

func _get_item_rect():
	screen_width = OS.get_window_size().width
	return Rect2(0, 0-image.get_height()/2 * scale.y, 1080 * scale.x, image.get_height() * scale.y)

func set_color(new_color):
	color = new_color
	create_sprites()


func set_image(new_image):
	image = new_image
	create_sprites()
		
func set_speed(new_speed):
	speed = new_speed
	create_sprites()
		
func set_movement_direction(new_movement_direction):
	movement_direction = new_movement_direction
	create_sprites()
		
func set_padding(new_padding):
	padding = new_padding
	create_sprites()
		
func set_scale(new_scale):
	scale = new_scale
	create_sprites()

func _ready():
	create_sprites()
	set_process(true)
	
func create_sprites():
	for child in get_children():
		if child extends Sprite:
			remove_child(child)
	texture_width = image.get_width() * scale.x
	screen_width = OS.get_window_size().width
	number_of_elements = ceil(screen_width / texture_width) + 2
	
	direction = 1 if movement_direction == "RIGHT" else -1
	
	for i in range(0, number_of_elements):
		var sprite = Sprite.new()
		sprite.set_pos(Vector2(i * (texture_width + padding) , 0))
		sprite.set_scale(scale)
		sprite.set_texture(image)
		sprite.set_modulate(color)
		add_child(sprite)
	



func _process(delta):
	var number_of_pixels_moved = (delta * speed * direction) #ceil((delta * speed * direction)/100)
	if number_of_pixels_moved >= 1:
		number_of_pixels_moved = ceil(number_of_pixels_moved)
	var children = get_children()		
	children.remove(0)				# First element: Placeholder
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
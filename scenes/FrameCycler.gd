extends Node2D

onready var animation_player = get_node("AnimationPlayer")

export(float) var speed = 1.0
export(Texture) var image = preload("res://assets/imgs/renegade_spritesheet3.png")
export(int) var HFrames = 10
export(int) var VFrames = 1

func _ready():
	var sprite = get_node("FrameCyclerSprite");
	sprite.set_texture(image)
	sprite.set_hframes(HFrames)
	sprite.set_vframes(VFrames)
	create_base_sprite_animation(HFrames, speed)	


func create_base_sprite_animation(HFrames, speed):
	var animation = animation_player.get_animation("BaseAnimation")
	animation.set_length(speed)
	animation.track_insert_key(0, 0, 0)
	animation.track_insert_key(0, speed, HFrames-1)
	animation.set_loop(true)
	animation_player.play("BaseAnimation")
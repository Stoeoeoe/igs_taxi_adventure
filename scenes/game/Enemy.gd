extends KinematicBody2D

export(Sample) var hit_sound
export(Texture) var default_texture = load("assets/imgs/enemies/default_enemy.png")

onready var sample_player = get_node("SamplePlayer2D")
onready var sprites = get_node("AnimatedSprite")
onready var sprite = get_node("Sprite")



func _ready():
	var sample_library = SampleLibrary.new()
	sample_player.set_sample_library(sample_library)
	sample_player.get_sample_library().add_sample("hit_sound", hit_sound)
	
	if default_texture:
		sprite.set_texture(default_texture)
	#var sprite_frames = SpriteFrames.new()
	#sprite_frames.set_frame("default", 0, base_sprite)
	#sprites.set_sprite_frames(sprite_frames)
	#sprites.set_animation("default")


func _on_enemy_hit( body ):
	if body.is_in_group("ball"):
		sample_player.play("hit_sound")
		pass # replace with function body

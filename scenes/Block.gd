extends StaticBody2D

#export(Sample) var hit_sound
#export(Texture) var default_texture = load("assets/imgs/blocks/default_block.png")
onready var sample_player = get_node("SamplePlayer2D")
onready var animation_player = get_node("AnimationPlayer")
onready var sprite = get_node("Sprite")

var block_data = null
export(String, "regular", "indestructable", "rabium") var block_type = "regular"

var score = 0

func _ready():
	block_data = data.get_item("blockdata", block_type)
	sprite.set_texture(load(block_data.background_sprite))

	sprite.set_hframes(block_data.animation_h_frames)
	sprite.set_vframes(block_data.animation_v_frames)
	if block_data.animation_h_frames > 1 or block_data.animation_v_frames > 1:
		var frames = (block_data.animation_h_frames * block_data.animation_v_frames) - 1
		create_base_sprite_animation(frames, block_data.animation_speed)	
	self.score = block_data.score
	sprite.set_modulate(block_data.block_color)
	if block_data.overlay:
		get_node("Overlay").set_texture(load(block_data.overlay))
#	var sample_library = SampleLibrary.new()
#	sample_player.set_sample_library(sample_library)
#	sample_player.get_sample_library().add_sample("hit_sound", hit_sound)
	

func _on_block_hit( body ):
	HUD.write(body.get_groups())
	if body.is_in_group("ball"):
		execute_block_action()
		if block_type == "regular" or block_type == "rabium":
			animation_player.play("DestructionAnimation")
			
			sample_player.play("block_destructable")
			
		if block_type == "indestructable":
			sample_player.play("block_indestructable")			

func _on_AnimationPlayer_finished():
	if animation_player.get_current_animation() == "DestructionAnimation":
		hide()
		queue_free()

func create_base_sprite_animation(frames, speed):
	var animation = animation_player.get_animation("BaseAnimation")
	animation.set_length(speed)
	animation.track_insert_key(0, 0, 0)
	animation.track_insert_key(0, speed, frames + 1)
	animation.set_loop(true)
	animation_player.play("BaseAnimation")
	
	
	


func execute_block_action():
	if block_data.victory_relevant:
		GameState.remove_block()
	if self.score > 0:
		GameState.add_score(score)
	pass
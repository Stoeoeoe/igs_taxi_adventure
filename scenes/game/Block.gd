tool
extends StaticBody2D

onready var sample_player = get_node("SamplePlayer")
onready var animation_player = get_node("AnimationPlayer")
onready var sprite = get_node("Sprite")

export(String, "regular", "indestructable", "rabium") var block_type = "regular" setget set_block_type
var block_data = null
var score = 0

func _ready():
	create_block()

func _get_item_rect():
	return Rect2(10,10,10,10)	
			
func set_block_type(new_blocktype):
	block_type = new_blocktype

	
func create_block():
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
	

func _on_block_hit( body ):
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
	

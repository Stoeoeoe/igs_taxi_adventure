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
	self.score = block_data.score
	if block_data.overlay:
		get_node("Overlay").set_texture(load(block_data.overlay))
#	var sample_library = SampleLibrary.new()
#	sample_player.set_sample_library(sample_library)
#	sample_player.get_sample_library().add_sample("hit_sound", hit_sound)
	
	if block_type == "regular":
		sprite.set_texture(preload("../assets/imgs/blocks/default_block.png"))
	elif block_type == "indestructable":
		sprite.set_texture(preload("../assets/imgs/blocks/indestructable_block.png"))
	elif block_type == "rabium":
		sprite.set_texture(preload("../assets/imgs/blocks/rabium_block.png"))

func _on_block_hit( body ):
	HUD.out(body.get_groups())
	if body.is_in_group("ball"):
		execute_block_action()
		if block_type == "regular" or block_type == "rabium":
			animation_player.play("DestructionAnim")
			
			sample_player.play("block_destructable")
			
		if block_type == "indestructable":
			sample_player.play("block_indestructable")			

func _on_AnimationPlayer_finished():
	if animation_player.get_current_animation() == "DestructionAnim":
		hide()
		queue_free()

func execute_block_action():
	if block_data.victory_relevant:
		GameState.remove_block()
	if self.score > 0:
		GameState.add_score(score)
	pass
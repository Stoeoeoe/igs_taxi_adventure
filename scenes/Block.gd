extends StaticBody2D

#export(Sample) var hit_sound
#export(Texture) var default_texture = load("assets/imgs/blocks/default_block.png")
onready var sample_player = get_node("SamplePlayer2D")
onready var animation_player = get_node("AnimationPlayer")
onready var sprite = get_node("Sprite")

export(String, "DEFAULT", "INDESTRUCTABLE", "RABIUM") var block_type = "DEFAULT"


func _ready():
#	var sample_library = SampleLibrary.new()
#	sample_player.set_sample_library(sample_library)
#	sample_player.get_sample_library().add_sample("hit_sound", hit_sound)
	
	if block_type == "DEFAULT":
		sprite.set_texture(preload("../assets/imgs/blocks/default_block.png"))
	elif block_type == "INDESTRUCTABLE":
		sprite.set_texture(preload("../assets/imgs/blocks/indestructable_block.png"))
	elif block_type == "RABIUM":
		sprite.set_texture(preload("../assets/imgs/blocks/rabium_block.png"))


func _on_block_hit( body ):
	if body.get("is_player"):
		if block_type == "DEFAULT" or block_type == "RABIUM":
			animation_player.play("DestructionAnim")
			sample_player.play("block_destructable")
			
		if block_type == "INDESTRUCTABLE":
			sample_player.play("block_indestructable")			
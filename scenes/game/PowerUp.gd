extends KinematicBody2D

export(String) var powerup_id = ""
var player_class = preload("res://scenes/game/Player.tscn")
var powerup_data = null
onready var sample_player = get_node("SamplePlayer")


func _ready():
	if powerup_id:
		powerup_data = data.get_item("powerup_data", powerup_id)
		add_child(powerup_data)
		
		get_node("Sprite").set_texture(load(powerup_data.texture))
		
		sample_player.set_sample_library(SampleLibrary.new())
		if powerup_data.sample:
			sample_player.get_sample_library().add_sample("collected", load(powerup_data.sample))
		
		if powerup_data.particles != null:
			remove_child(get_node("Particles2D"))
			var particle_effect_class = load(powerup_data.particles)
			var particle_effect_instance = particle_effect_class.instance()
			particle_effect_instance.set_name("Particles2D")
			add_child(particle_effect_instance)
			
func _on_EffectArea_body_enter( body ):
	print(body.get_groups())
	if body.is_in_group("ball"):
		GameState.emit_signal("powerup_collected", powerup_data)
		sample_player.play("collected")
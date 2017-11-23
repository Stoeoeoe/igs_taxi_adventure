extends KinematicBody2D

export(String) var powerup_id = ""
var player_class = preload("res://scenes/game/Player.tscn")


func _ready():
	if powerup_id:
		var powerup_data = data.get_item("powerup_data", powerup_id)
		add_child(powerup_data)
		get_node("Sprite").set_texture(load(powerup_data.texture))
		
		if powerup_data.particles != null:
			remove_child(get_node("Particles2D"))
			var particle_effect_class = load(powerup_data.particles)
			var particle_effect_instance = particle_effect_class.instance()
			particle_effect_instance.set_name("Particles2D")
			add_child(particle_effect_instance)
			
func _on_EffectArea_body_enter( body ):
	if body.is_in_group("ball"):
		GameState.emit_signal("powerup_collected", powerup_id)
		
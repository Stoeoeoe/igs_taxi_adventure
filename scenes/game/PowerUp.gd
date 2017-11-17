extends KinematicBody2D

export(String) var powerup_id = ""

func _ready():
	if powerup_id:
		var powerup_data = data.get_item("powerup_data", powerup_id)
		get_node("Sprite").set_texture(load(powerup_data.texture))
		if powerup_data.particles != null:
			remove_child(get_node("Particles2D"))
			var particle_effect_class = load(powerup_data.particles)
			var particle_effect_instance = particle_effect_class.instance()
			particle_effect_instance.set_name("Particles2D")
			add_child(particle_effect_instance)
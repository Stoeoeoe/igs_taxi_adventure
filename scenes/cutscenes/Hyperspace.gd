extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	HUD.deactivate()
	pass
	get_node("AnimationPlayer").play("ShakeTrack")
extends Node

var target_level = "res://scenes/screens/LevelMenu.tscn"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _on_Button_pressed():
	get_tree().change_scene(target_level)

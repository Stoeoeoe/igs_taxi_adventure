extends Node

onready var hyperspace = get_node("Hyperspace")
onready var end_player = get_node("EndPlayer")

var target_level = "res://scenes/screens/MainMenu.tscn"

func _ready():
	hyperspace.set_ship_to_end_pos()
	end_player.play("EndAnimation")

func _on_Button_pressed():
	SceneSwitcher.change_scene(target_level)

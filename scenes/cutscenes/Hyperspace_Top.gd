extends Node

onready var animation_player = get_node("AnimationPlayer")
onready var terminal = get_node("Terminal")

func _ready():
	animation_player.play("TopAnimation")
	
func pause_text():
	animation_player.stop();

func _on_StopButton_pressed():
	terminal.clear()
	animation_player.play("TopAnimation")

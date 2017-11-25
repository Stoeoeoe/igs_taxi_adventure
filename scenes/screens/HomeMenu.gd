extends Control

onready var animation_player = get_node("AnimationPlayer")

var unlocked_levels = []

signal menu_selected(menu)
signal back_button_pressed

func _ready():
	animation_player.play("ShinyAnimation")

func _on_BackToMainMenuButton_button_down():
	emit_signal("back_button_pressed")

func _on_MenuButton_selected(menu):
	emit_signal("menu_selected", menu)


func _on_HomeMenu_visibility_changed():
	if is_visible():
		get_node("VBoxContainer/StartButton").grab_focus()
		

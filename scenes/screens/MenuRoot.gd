extends Control

onready var home_menu = get_node("HomeMenu")
onready var settings_menu = get_node("SettingsMenu")
onready var level_menu = get_node("LevelMenu")

onready var sample_player = get_node("CentralSamplePlayer")
onready var animation_player = get_node("AnimationPlayer")

var interaction_possible = true

func _ready():
	HUD.hide_gameoverlay()
	home_menu.connect("menu_selected", self, "_on_HomeMenu_menu_selected", [])

func _on_HomeMenu_menu_selected( menu ):
	if not interaction_possible:
		return
		
	if menu == "save_the_universe":
		animation_player.play("StartGame")
		interaction_possible = false
	elif menu == "settings":
		settings_menu.show()
		home_menu.hide()
		sample_player.play("select_menu")
		pass
	elif menu == "high_score":
		sample_player.play("select_menu")
		pass
	elif menu == "credits_and_licenses":
		sample_player.play("select_menu")
		pass


func _on_HomeMenu_back_button_pressed():
	sample_player.play("select_menu")
	home_menu.show()
	settings_menu.hide()
	level_menu.hide()

func _on_SettingsMenu_menu_closed():
	sample_player.play("select_menu")
	home_menu.show()
	settings_menu.hide()

func start_game():
	get_tree().change_scene("res://scenes/cutscenes/HyperspaceTop.tscn")

	

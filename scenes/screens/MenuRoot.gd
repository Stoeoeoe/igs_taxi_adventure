extends Control

onready var home_menu = get_node("HomeMenu")
onready var settings_menu = get_node("SettingsMenu")
onready var level_menu = get_node("LevelMenu")
onready var highscore_menu = get_node("HighscoreMenu")
onready var credits = get_node("CreditsAndLicensesMenu")

onready var sample_player = get_node("CentralSamplePlayer")
onready var animation_player = get_node("AnimationPlayer")
onready var stream_player = get_node("CentralStreamPlayer")

var interaction_possible = true

func _ready():
	HUD.hide_gameoverlay()
	level_menu.stop_music()
	get_node("HomeMenu").get_node("VBoxContainer/StartButton").grab_focus()

func _on_HomeMenu_menu_selected( menu ):
	if interaction_possible:
		if menu == "StartStory":
			animation_player.play("StartGame")
			interaction_possible = false
		elif menu == "Exit":
			get_tree().quit()
		else:
			open_menu(menu)


func open_menu(menu):
	sample_player.play("select_menu")
	get_tree().call_group(SceneTree.GROUP_CALL_REALTIME, "screen", "hide")
	get_node(menu).show()
	


func start_game():
	SceneSwitcher.change_scene("res://scenes/cutscenes/HyperspaceTop.tscn")


func _on_MenuButton_selected():
	pass # replace with function body

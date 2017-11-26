extends CanvasLayer

export(Texture) var life_texture = preload("res://assets/imgs/life.png")

onready var log_entries_label = get_node("RootControl/GameOverlay/LogEntries")
onready var score_label = get_node("RootControl//GameOverlay/ScoreLabel")
onready var crt_shader_panel = get_node("RootControl/CRTShaderPanel")
onready var win_overlay = get_node("RootControl/GameOverlay/WinOverlay")
onready var animation_player = get_node("AnimationPlayer")
onready var life_box = get_node("RootControl/GameOverlay/LifeBox")
onready var title_label = get_node("RootControl/GameOverlay/TitleLabel")


var log_entries = []
var log_string = ""
export(int) var maximum_lines = 3

func _ready():
	GameState.connect("game_won", self, "show_win_overlay")
	GameState.connect("gameover", self, "show_lose_overlay")
	GameState.connect("level_ready", self, "set_hud_to_level_mode")
	log_entries_label.set_text("Hyper Kernel v. 0.96 loaded!")
	hide_gameoverlay()

func write(new_log_entry):
	new_log_entry = str(new_log_entry)
	# Delete last log entry if log too long
	if log_entries.size() >= maximum_lines:
		log_entries.pop_front()
	
	log_entries.push_back(new_log_entry)
	
	log_string = ""
	for entry in log_entries:
		log_string += entry + "\n"
	log_entries_label.set_text(log_string)

func set_title(text):
	title_label.set_text(text)

func add_life():
	var life_texture_frame = TextureFrame.new()
	life_texture_frame.set_texture(life_texture)
	life_texture_frame.set_size(life_texture.get_size())
	life_box.add_child(life_texture_frame)
	
func remove_life():
	var first_child = life_box.get_child(0)
	life_box.remove_child(first_child)
	
func set_lives(number_of_lives):
	for child in life_box.get_children():
		life_box.remove_child(child)
	pass
	for i in range(0, number_of_lives):
		add_life()
	pass

func set_hud_to_level_mode():
	get_node("CanvasModulate").set_color(Color(1,1,1))
	show_hud()
	show_gameoverlay()
	hide_win_overlay()
	win_overlay.hide()
	animation_player.stop_all()
	HUD.clear_log()
	

func show_hud():
	get_node("RootControl").set_hidden(false)

func show_gameoverlay():
	get_node("RootControl/GameOverlay").show()

func hide_gameoverlay():
	get_node("RootControl/GameOverlay").hide()

func hide_hud():
	get_node("RootControl").set_hidden(true)

func set_score(score):
	score_label.set_text(str(score))

func disable_crt():
	crt_shader_panel.crt_behavior = "OFF"
	
func enable_crt():
	crt_shader_panel.crt_behavior = "SETTINGS"
	
func show_win_overlay():
	animation_player.play("GameWonAnimation")
	
func show_lose_overlay():
	animation_player.play("GameLostAnimation")
	
func hide_win_overlay():
	win_overlay.hide()	

func clear_log():
	log_entries_label.set_text("")
	log_string = ""
	log_entries = []

func _on_AnimationPlayer_finished():
	if animation_player.get_current_animation() == "GameWonAnimation":
		GameState.go_to_intermediate_scene()
	elif animation_player.get_current_animation() == "GameLostAnimation":
		GameState.handle_game_over()
		
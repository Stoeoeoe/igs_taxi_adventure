extends Panel

onready var stream_player = get_node("CentralStreamPlayer")
onready var light_container = get_node("BlinkenLights")
onready var animation_player = get_node("AnimationPlayer2")
onready var sample_player = get_node("CentralSamplePlayer")

var level_selection_bubbles = []
var max_floating = 20
var lights
var lights_active = IntArray()
var lights_time_to_wait  = FloatArray()

func _ready():
	level_selection_bubbles = get_tree().get_nodes_in_group("level_selection_bubble")
	level_selection_bubbles.sort_custom(self, "sort_bubbles")
	lights = light_container.get_children()
	lights_active.resize(lights.size())
	lights_time_to_wait.resize(lights.size())
	for i in range(lights.size()):
		lights_active[i] = 0
	#animation_player.play("TextAnimation")

	var i = 0
	for bubble in level_selection_bubbles:
		bubble.status = GameState.level_status[i]
		bubble.connect("level_selected", self, "select_level", [])
		bubble.connect("level_selected_failed", self, "select_level_failed", [])
		i += 1
	
	get_node("Lines").level_selection_bubbles = level_selection_bubbles
	set_process(true)
		
func _process(delta):
	handle_blinken_lights(delta)

				
func sort_bubbles(first_element, second_element):
	return true if first_element.level < second_element.level else false

func select_level(level):
	GameState.current_level = level
	SceneSwitcher.change_scene("res://scenes/levels/Level" + str(level) + ".tscn")


func select_level_failed(level):
	get_node("IGSCamera").shake(0.2, 5)
	animation_player.play("ErrorAnimation")
	
func play_music():
	stream_player.play()
	
func stop_music():
	stream_player.stop()
	
func handle_blinken_lights(delta):
	if not self.is_visible():
		return
	for i in range(lights.size()):
		if lights_active[i] == 1:
			lights_time_to_wait[i] -= delta
			if lights_time_to_wait[i] < 0:
				lights[i].hide()
				lights_active[i] = 0
	for j in range(lights.size()):
		if lights_active[j] == 0:
			if randi() % 75 == 0:
				lights_active[j] = 1
				lights[j].show()
				if j > 12:
					sample_player.set_default_pan(0.5)
					sample_player.set_default_pitch_scale(rand_range(0.2,0.5))
				else:
					sample_player.set_default_pan(-0.5)
					sample_player.set_default_pitch_scale(rand_range(0.6,1.2))
				sample_player.play("blinkenlights")
				lights_time_to_wait[j] = rand_range(1,5)
	#ligts = light_container.get_children()

func _on_LevelMenu_visibility_changed():
	if is_hidden():
		stop_music()
	else:
		play_music()
extends Node2D

export (int) var spawn_rate = 10
export (String) var enemy_scene_path = "" 
export (bool) var auto_spwan = false
export (int) var max_number_of_entities = 2

var rnd = 0.0
var allow_spwan = false;
var number_of_entities = 0;

func _ready():
	randomize()
	GameState.connect("enemy_killed", self, "entity_died")
	if auto_spwan:
		set_process(true)

func _process(delta):
	if allow_spwan:
		rnd = randi() % spawn_rate
		if rnd == 0:
			self.spawn()

func spawn():
	var root =  get_tree().get_edited_scene_root()
	var scene = load(enemy_scene_path)
	#scene.set_pos(self.get_pos())
	#root.add_child(scene)
	#scene.set_owner(root)
	number_of_entities += 1
	if number_of_entities >= max_number_of_entities:
		allow_spwan = false
		
func start_spwawning():
	set_process(true)
	
func stop_spawing():
	set_process(false)
	
func entity_died(type, id):
	number_of_entities -= 1
	if number_of_entities < max_number_of_entities:
		allow_spwan = true;
	
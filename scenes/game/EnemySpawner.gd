extends Node2D

export (int) var spawn_rate = 10
export (PackedScene) var enemy_scene
export (bool) var auto_spwan = false
export (int) var max_number_of_entities = 2

var rnd = 0.0
var allow_spawn = false;
var number_of_entities = 0;

func _ready():
	randomize()
	GameState.connect("enemy_killed", self, "entity_died")
	if auto_spwan:
		set_process(true)

func _process(delta):
	if allow_spawn:
		rnd = randi() % spawn_rate
		if rnd == 0:
			self.spawn()

func spawn():
	var world =  get_tree().get_nodes_in_group("world")[0]
	var instance = enemy_scene.instance()
	instance.set_pos(get_pos())
	world.get_node("Enemies").add_child(instance)
	
	number_of_entities += 1
	if number_of_entities >= max_number_of_entities:
		allow_spawn = false
		
func start_spawning():
	set_process(true)
	
func stop_spawning():
	set_process(false)
	
func entity_died(type, id):
	number_of_entities -= 1
	if number_of_entities < max_number_of_entities:
		allow_spawn = true;
	
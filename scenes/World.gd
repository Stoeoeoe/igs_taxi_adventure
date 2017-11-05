extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	randomize()
	set_process(true)
	
	
func _process():
	pass
	


func _on_Timer_timeout():
	var random_number = rand_range(0, 10000)
	
	

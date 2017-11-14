extends Sprite

export (float) var attack_time = 0.1
export (float) var sustain_time = 3.0
export (float) var decay_time = 0.5
export (float) var attack_variance = 0.0
export (float) var sustain_varaince = 0.0
export (float) var decay_variance = 0.0
export (Vector2) var scale_min = Vector2(1,1)
export (Vector2) var scale_max = Vector2(1,1)
export (bool) var randomize_time = false
export (bool) var randomize_scale = false
export (bool) var replay = true
export (bool) var randomize_blink_size = true
export (bool) var randomize_blink_time = true

var attack
var sustain
var decay
var scale
var attack_started = false
var sustain_started = false
var decay_started = false
var time_since_last_framechange = 0.0


func _ready():
	set_opacity(0.0)
	set_process(true)
	play()

func _process(delta):
	#print(delta)
	time_since_last_framechange += delta
	if decay_started:
		if time_since_last_framechange >= decay:
			set_opacity(0.0);
			if replay:
				attack_started = true
				time_since_last_framechange = 0.0
			else:
				attack_started = false
			sustain_started = false
			decay_started = false
		else:
			set_opacity( 1 - (time_since_last_framechange / decay))
	elif sustain_started:
		if time_since_last_framechange >= sustain:
			time_since_last_framechange = 0.0
			decay_started = true
			#print("######################## DECAY")
	elif attack_started:
		if time_since_last_framechange >= attack:
			set_opacity(1.0);
			time_since_last_framechange = 0.0
			sustain_started = true
			#print("######################## SUSTAIN")
		else:
			set_opacity(time_since_last_framechange / attack)
	#print(get_opacity())
	
func play():
	attack = get_randomized_value(attack_time, attack_variance, randomize_time)
	sustain = get_randomized_value(sustain_time, sustain_varaince, randomize_time)
	decay = get_randomized_value(decay_time, decay_variance, randomize_time)
	scale = Vector2(get_randomized_value(get_scale().x, scale_max.x - scale_min.x, randomize_scale), get_randomized_value(get_scale().y, scale_max.y - scale_min.y, randomize_scale))
	attack_started = true
	sustain_started = false
	decay_started = false
	time_since_last_framechange = 0.0
	
	
	pass
	
func get_randomized_value(base_value, variance, is_randomized):
	if is_randomized:
		return rand_range(base_value - variance, base_value + variance)
	else:
		return base_value
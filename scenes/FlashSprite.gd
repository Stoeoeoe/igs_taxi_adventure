tool

extends Sprite

export (float) var attack_time = 0.1 setget set_attack_time 
export (float) var sustain_time = 3.0 setget set_sustain_time 
export (float) var decay_time = 0.5 setget set_decay_time 
export (float) var pause_duration = 0.0 setget set_pause_duration
export (float) var attack_variance = 0.0 setget set_attack_variance
export (float) var sustain_variance = 0.0 setget set_sustain_variance
export (float) var decay_variance = 0.0 setget set_decay_variance 
export (float) var pause_variance = 0.0 setget set_pause_variance 
export (Vector2) var scale_min = Vector2(1,1) setget set_scale_min 
export (Vector2) var scale_max = Vector2(1,1) setget set_scale_max
export (bool) var randomize_time = false setget set_randomize_time
export (bool) var randomize_scale = false setget set_randomize_scale
export (bool) var randomize_pause = false setget set_randomize_pause
export (bool) var replay = true setget set_replay


var attack
var sustain
var decay
var scale
var pause
var attack_started = false
var sustain_started = false
var decay_started = false
var pause_started = false
var time_since_last_framechange = 0.0
var base_scale = Vector2(1,1)

func set_attack_time(new_attack_time):
	attack_time = new_attack_time
	play()
	
func set_sustain_time(new_sustain_time):
	sustain_time = new_sustain_time
	play()	

func set_decay_time(new_decay_time):
	decay_time = new_decay_time
	play()	

func set_attack_variance(new_attack_variance):
	attack_variance = new_attack_variance
	play()
	
func set_sustain_variance(new_sustain_variance):
	sustain_variance = new_sustain_variance
	play()	

func set_decay_variance(new_decay_variance):
	decay_variance = new_decay_variance
	play()	
	
func set_pause_variance(new_pause_variance):
	pause_variance = new_pause_variance
	play()		
	
func set_pause_duration(new_pause_duration):
	pause_duration = new_pause_duration
	play()
	
func set_scale_min(new_scale_min):
	scale_min = new_scale_min
	play()
	
func set_scale_max(new_scale_max):
	scale_max = new_scale_max
	play()
	
func set_randomize_time(new_randomize_time):
	randomize_time = new_randomize_time
	play()
	
func set_randomize_scale(new_randomize_scale):
	randomize_scale = new_randomize_scale
	play()	
	
func set_randomize_pause(new_randomize_pause):
	randomize_pause = new_randomize_pause
	play()	
	
func set_replay(new_replay):
	replay = new_replay
	if replay:
		play()
	else:
		stop(true)


func _ready():
	set_process(true)
	base_scale = get_scale()
	play()

func _process(delta):
	#print(delta)
	time_since_last_framechange += delta
	if pause_started:
		if time_since_last_framechange >= pause:
			if replay:
				play()
			else:
				stop(false)
	elif decay_started:
		if time_since_last_framechange >= decay:
			time_since_last_framechange = 0.0
			pause_started = true;
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
	sustain = get_randomized_value(sustain_time, sustain_variance, randomize_time)
	decay = get_randomized_value(decay_time, decay_variance, randomize_time)
	pause = get_randomized_value(pause_duration, pause_variance, randomize_pause)
	scale = Vector2(get_randomized_value((scale_max.x + scale_min.x)/2, scale_max.x - scale_min.x, randomize_scale), get_randomized_value((scale_max.y + scale_min.y)/2, scale_max.y - scale_min.y, randomize_scale))
	
	attack_started = true
	sustain_started = false
	decay_started = false
	pause_started = false
	set_scale(scale)
	set_opacity(0.0);
	time_since_last_framechange = 0.0

	pass
	
func stop(show_sprite):
	if show_sprite:
		set_opacity(1.0)
	else:
		set_opacity(0.0)
	attack_started = false
	sustain_started = false
	decay_started = false
	pause_started = false;
	set_scale(base_scale)
	
func get_randomized_value(base_value, variance, is_randomized):
	if is_randomized:
		return rand_range(base_value - variance/2, base_value + variance/2)
	else:
		return base_value
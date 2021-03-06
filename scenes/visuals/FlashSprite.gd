tool

extends Sprite

export (Texture) var sprite_texture = get_texture() setget set_flash_texture
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
export (bool) var randomize_frames = false setget set_randomize_frames
export (int, "STATIC", "FADE_IN_FROM_ZERO", "FADE_IN_FROM_MIN", "FADE_IN_FROM_MAX") var scale_fade_in_mode = 0
export (int, "STATIC", "FADE_OUT_TO_ZERO", "FADE_OUT_TO_MIN", "FADE_OUT_TO_MAX") var scale_fade_out_mode = 0
export (bool) var replay = true setget set_replay

signal flash_start
signal flash_end

var attack = 0
var sustain = 0
var decay = 0
var scale = 0
var pause = 0
var transition_factor = 0
var frame_number = 1
var attack_started = false
var sustain_started = false
var decay_started = false
var pause_started = false
var time_since_last_framechange = 0.0
var base_scale = Vector2(1,1)

func set_flash_texture(new_flas_texture):
	sprite_texture = new_flas_texture
	set_texture(new_flas_texture)
	set_scale(Vector2(1,1))
	base_scale = get_scale()
	frame_number = get_hframes() * get_vframes()	
	

func set_randomize_time(new_randomize_time):
	randomize_time = new_randomize_time
	
func set_randomize_scale(new_randomize_scale):
	randomize_scale = new_randomize_scale
	
func set_randomize_pause(new_randomize_pause):
	randomize_pause = new_randomize_pause

func set_randomize_frames(new_randomize_frames):
	randomize_frames = new_randomize_frames


func set_attack_time(new_attack_time):
	attack_time = new_attack_time
	
func set_sustain_time(new_sustain_time):
	sustain_time = new_sustain_time

func set_decay_time(new_decay_time):
	decay_time = new_decay_time

func set_attack_variance(new_attack_variance):
	attack_variance = new_attack_variance
	
func set_sustain_variance(new_sustain_variance):
	sustain_variance = new_sustain_variance

func set_decay_variance(new_decay_variance):
	decay_variance = new_decay_variance
	
func set_pause_variance(new_pause_variance):
	pause_variance = new_pause_variance
	
func set_pause_duration(new_pause_duration):
	pause_duration = new_pause_duration
	
func set_scale_min(new_scale_min):
	scale_min = new_scale_min
	
func set_scale_max(new_scale_max):
	scale_max = new_scale_max

	
func set_replay(new_replay):
	
	replay = new_replay
	if replay:
		play()
	else:
		stop(true)


func _ready():
	set_process(true)
	base_scale = get_scale()
	frame_number = get_hframes() * get_vframes()
	play()

func _process(delta):
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
			set_opacity(0.0)
			pause_started = true
			if is_inside_tree() and not get_tree().is_editor_hint():
				emit_signal("flash_end")
		else:
			set_opacity( 1 - (time_since_last_framechange / decay))
			calculate_scale()
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
			calculate_scale()
	#print(get_opacity())
	
func play():
	if is_inside_tree() and not get_tree().is_editor_hint():
		emit_signal("flash_start")
	if randomize_frames and frame_number > 1:
		set_frame(rand_range(1, frame_number))
	attack = get_randomized_value(attack_time, attack_variance, randomize_time)
	sustain = get_randomized_value(sustain_time, sustain_variance, randomize_time)
	decay = get_randomized_value(decay_time, decay_variance, randomize_time)
	pause = get_randomized_value(pause_duration, pause_variance, randomize_pause)
	
	if randomize_scale == false:
		scale = base_scale
	else:
		scale = Vector2(get_randomized_value((scale_max.x + scale_min.x)/2, scale_max.x - scale_min.x, randomize_scale), get_randomized_value((scale_max.y + scale_min.y)/2, scale_max.y - scale_min.y, randomize_scale))
	attack_started = true
	sustain_started = false
	decay_started = false
	pause_started = false
	#set_scale(scale)
	#calculate_scale()
	set_opacity(0.0);
	time_since_last_framechange = 0.0
	
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
	
func calculate_scale():
	if decay_started:
		if scale_fade_out_mode == 0 or decay == 0: # STATIC
			set_scale(scale)
			return
		transition_factor = 1-(time_since_last_framechange / decay) # 0-1
		#print(transition_factor)
		if scale_fade_out_mode == 1: # TO 0
			set_scale(Vector2(transition_factor * scale.x, transition_factor * scale.y))
		elif scale_fade_out_mode == 2: # TO MIN
			set_scale( Vector2((transition_factor * (scale.x - scale_min.x)) + scale_min.x, (transition_factor * (scale.y - scale_min.y)) + scale_min.y) )
		elif scale_fade_out_mode == 3: # TO MAX
			set_scale( Vector2(scale_max.x -(transition_factor * (scale_max.x - scale.x)) , scale_max.y - (transition_factor * (scale_max.y - scale.y))) )

	elif attack_started:
		if scale_fade_in_mode == 0 or attack == 0: # STATIC
			set_scale(scale)
			return
		transition_factor = time_since_last_framechange / attack # 0-1
		#print(transition_factor)
		if scale_fade_in_mode == 1: # FROM 0
			set_scale(Vector2(transition_factor * scale.x, transition_factor * scale.y))
		elif scale_fade_in_mode == 2: # FROM MIN
			set_scale( Vector2((transition_factor * (scale.x - scale_min.x)) + scale_min.x, (transition_factor * (scale.y - scale_min.y)) + scale_min.y) )
		elif scale_fade_in_mode == 3: # FROM MAX
			set_scale( Vector2(scale_max.x -(transition_factor * (scale_max.x - scale.x)) , scale_max.y - (transition_factor * (scale_max.y - scale.y))) )

	
func get_randomized_value(base_value, variance, is_randomized):
	if is_randomized:
		return rand_range(base_value - variance/2, base_value + variance/2)
	else:
		return base_value
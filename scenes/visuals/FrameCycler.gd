tool
extends Sprite

export(float) var duration = 1.0 setget set_duration

export(int) var hframes = 10 setget set_new_hframes
export(int) var vframes = 1 setget set_new_vframes
export(bool) var preview_animation = true setget set_preview_animation
export(bool) var reverse setget set_reverse

var time_since_last_framechange = 0.0
var time_per_frame = 0.0
var total_frames = 0

func set_new_hframes(new_hframes):
	hframes = new_hframes
	set_hframes(hframes)


func set_new_vframes(new_vframes):
	vframes = new_vframes
	set_vframes(vframes)

	
func set_duration(new_duration):
	duration = new_duration
	time_per_frame = duration / total_frames
	
func set_reverse(new_reverse):
	reverse = new_reverse


func set_preview_animation(new_preview_animation):
	preview_animation = new_preview_animation	

func _ready():
	self.set_hframes(hframes)
	self.set_vframes(vframes)
	total_frames = hframes * vframes	
	time_per_frame = duration / total_frames
	set_process(true)

func _process(delta):
	if preview_animation:
		time_since_last_framechange += delta
		if time_since_last_framechange > time_per_frame:
			time_since_last_framechange = 0
			if reverse:
				if get_frame() == 0:
					set_frame(total_frames-1)
				else:
					set_frame(get_frame()-1)
			else:
				if get_frame() == total_frames -1:
					set_frame(0)
				else:
					set_frame(get_frame()+1)

				
tool
extends Sprite

onready var animation_player = get_node("AnimationPlayer")

export(float) var duration = 1.0 setget set_duration
export(Texture) var image = preload("res://icon.png") setget set_image
export(int) var hframes = 10 setget set_hframes
export(int) var vframes = 1 setget set_vframes
export(bool) var preview_animation = true setget set_preview_animation
export(bool) var reverse setget set_reverse

var animation_name = "BaseAnimation"

func set_preview_animation(new_preview_animation):
	if  animation_player and get_tree().is_editor_hint():
		preview_animation = new_preview_animation
		set_frame(0)
		if animation_player.is_playing():
			animation_player.stop()
		else:
			play()

func set_hframes(new_hframes):
	hframes = new_hframes
	create_base_sprite_animation(hframes*vframes, duration)

func set_vframes(new_vframes):
	vframes = new_vframes
	create_base_sprite_animation(hframes*vframes, duration)
	
func set_duration(new_duration):
	duration = new_duration
	create_base_sprite_animation(hframes*vframes, duration)

func set_image(new_image):
	image = new_image
	self.set_texture(image)
	create_base_sprite_animation(hframes*vframes, duration)
	
func set_reverse(new_reverse):
	reverse = new_reverse
	create_base_sprite_animation(hframes*vframes, duration)

func _ready():
	self.set_texture(image)
	self.set_hframes(hframes)
	self.set_vframes(vframes)
	create_base_sprite_animation(hframes * vframes, duration)	


func create_base_sprite_animation(frames, duration):
	if animation_player:
		if animation_player and animation_player.has_animation("BaseAnimation"):
			animation_player.remove_animation(animation_name)
	#	var animation = animation_player.get_animation("BaseAnimation")
		var animation = Animation.new()
		animation_player.add_animation(animation_name, animation)
		var track = animation.add_track(Animation.TYPE_VALUE)
		animation.track_set_interpolation_type(track, Animation.INTERPOLATION_LINEAR)
		animation.value_track_set_update_mode(track, Animation.UPDATE_CONTINUOUS)
	
		animation.track_set_path(track, ".:frame")	
		animation.set_length(duration)
		animation.set_loop(true)
		
		animation.track_insert_key(track, 0, 0)
		animation.track_insert_key(track, duration, frames)

	
		if(get_tree().is_editor_hint() and preview_animation) or not get_tree().is_editor_hint():
			play()
		
func play():
	if reverse:
		animation_player.play_backwards(animation_name)
	else:
		animation_player.play(animation_name)
tool
extends EditorPlugin

func _enter_tree():
    add_custom_type("CentralStreamPlayer", "StreamPlayer", preload("central_sound_stream_player.gd"), preload("icon_stream_player.png"))
    add_custom_type("CentralSamplePlayer", "SamplePlayer", preload("central_sound_sample_player.gd"), preload("icon_sample_player.png"))


func _exit_tree():
    remove_custom_type("CentralStreamPlayer")
    remove_custom_type("CentralSamplePlayer")

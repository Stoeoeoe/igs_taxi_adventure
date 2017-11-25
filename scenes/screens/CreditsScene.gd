extends Panel

signal menu_closed

func _ready():
	pass


func _on_CloseButton_pressed():
	emit_signal("menu_closed")

extends Container


func set_entry(rank, name, score):
	get_node("Rank").set_text(str(rank))
	get_node("Name").set_text(str(name))
	get_node("Score").set_text(str(score))
	
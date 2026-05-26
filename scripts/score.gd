extends Label


func _process(delta: float) -> void:
	text = "Score: %d" % Grid.score

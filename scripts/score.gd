extends Label

@export var player = 1

func _ready():
	if player == 1:
		self_modulate = Color.HOT_PINK
	else:
		self_modulate = Color.CYAN

func _process(delta: float) -> void:
	text = "Score: %d" % Grid.scores[player - 1]

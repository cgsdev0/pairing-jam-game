extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	Grid.game_end.connect(on_end)
	
func on_end():
	var winner = 1
	if Grid.scores[1] > Grid.scores[0]:
		winner = 2
	elif Grid.scores[0] == Grid.scores[1]:
		winner = 0
	
	if winner == 0:
		$Winner.self_modulate = Color.WHITE
		$Winner.text = "Tie!"
	elif winner == 1:
		$Winner.self_modulate = Color.HOT_PINK
		$Winner.text = "Player 1 Wins!"
	elif winner == 2:
		$Winner.self_modulate = Color.CYAN
		$Winner.text = "Player 2 Wins!"
	show()

func _process(delta: float) -> void:
	if visible && (Input.is_action_just_pressed("one_player") or Input.is_action_just_pressed("two_player")):
		hide()
		Grid.score = 0
		Grid.reset()
		get_tree().reload_current_scene()

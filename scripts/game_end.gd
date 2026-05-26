extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	Grid.game_end.connect(on_end)
	
func on_end():
	show()

func _process(delta: float) -> void:
	if visible && Input.is_action_just_pressed("one_player"):
		hide()
		Grid.score = 0
		Grid.reset()
		Grid.players = 1
		get_tree().reload_current_scene()
	if visible && Input.is_action_just_pressed("two_player"):
		hide()
		Grid.score = 0
		Grid.reset()
		Grid.players = 2
		get_tree().reload_current_scene()

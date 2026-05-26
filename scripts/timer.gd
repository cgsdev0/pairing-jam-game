extends Label


var timer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.start(100)
	timer.timeout.connect(on_timer)
	
func on_timer():
	Grid.game_end.emit()

func _process(delta: float) -> void:
	text = "Time left: %d" % int(timer.time_left)

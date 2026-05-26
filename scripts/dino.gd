extends Node2D

@export var coords: Vector2i

func is_valid(direction: Vector2i):
	var new_coords = coords + direction
	if new_coords.x < 0 or new_coords.x >= 20 or new_coords.y < 0 or new_coords.y >= 16:
		return false
	else:
		return true

func think():
	var possible_moves = [Vector2i(-1, 0), Vector2i(1, 0), Vector2i(0, -1), Vector2i(0, 1),
						  Vector2i(-1, -1), Vector2i(1, 1), Vector2i(-1, 1), Vector2i(1, -1)]
	var random_choice = possible_moves.filter(is_valid).pick_random()
	move(random_choice)

func move(direction: Vector2i) -> void:
	coords += direction
	var t = create_tween()
	t.tween_property(self, "position", coords * 20.0, 0.1)

func _ready() -> void:
	position = coords * 20.0
	$AnimatedSprite2D.play("default")
	var move_timer = Timer.new()
	add_child(move_timer)
	move_timer.start(1)
	move_timer.timeout.connect(think)
	
func _process(delta: float) -> void:
	pass

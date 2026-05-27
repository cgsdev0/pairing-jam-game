extends Node2D

@export var coords: Vector2i

func is_valid(coords: Vector2i):
	return func(direction: Vector2i):
		var new_coords = coords + direction
		if new_coords.x < 0 or new_coords.x >= 16 or new_coords.y < 1 or new_coords.y >= 12:
			return false
		else:
			return true

func think():
	var nearest = bfs()
	if nearest != null:
		var dy = nearest.y - coords.y
		var dx = nearest.x - coords.x
		var idk = Vector2i(dx, dy).clamp(Vector2i(-1, -1), Vector2i(1, 1))
		move(idk)
		pass
	else:
		var possible_moves = [Vector2i(-1, 0), Vector2i(1, 0), Vector2i(0, -1), Vector2i(0, 1),
							  Vector2i(-1, -1), Vector2i(1, 1), Vector2i(-1, 1), Vector2i(1, -1)]
		var random_choice = possible_moves.filter(is_valid(coords)).pick_random()
		move(random_choice)

func bfs():
	var q = [coords]
	var visited = {}
	while !q.is_empty():
		var next = q.pop_front()
		if visited.get(str(next), false):
			continue
		if Grid.is_food(next):
			return next
		visited[str(next)] = true
		var possible_moves = [Vector2i(-1, 0), Vector2i(1, 0), Vector2i(0, -1), Vector2i(0, 1),
						  Vector2i(-1, -1), Vector2i(1, 1), Vector2i(-1, 1), Vector2i(1, -1)]
		var filtered = possible_moves.filter(is_valid(next))
		for f in filtered:
			q.append(next + f)
	return null
		
func move(direction: Vector2i) -> void:
	if Grid.game_over:
		return
	coords += direction
	$Move.play()
	# eat food if there is any
	if Grid.is_food(coords):
		var p = 0
		for acorn in %Acorns.get_children():
			if acorn.coords == coords:
				p = acorn.player
				acorn.queue_free()
				var added = Grid.add_score(p)
				var pitch = (added - 1) / 8.0 + 1.0
				$Eat.pitch_scale = pitch
				$Eat.play()
				spawn_text(p, added)
		Grid.grid[coords.y][coords.x] = Grid.Cell.EMPTY
		
	var t = create_tween()
	t.tween_property(self, "position", coords * 20.0, 0.1)

var BUBBLE = preload("res://scenes/bubble_text.tscn")
func spawn_text(player, score):
	var b = BUBBLE.instantiate()
	b.self_modulate = Color.HOT_PINK
	if player == 2:
		b.self_modulate = Color.CYAN
	b.text = "+" + str(score)
	b.global_position = coords * 20.0 + Vector2(20 if coords.x < 8 else -40, -10)
	get_parent().add_child(b)
	
func _ready() -> void:
	position = coords * 20.0
	$AnimatedSprite2D.play("default")
	var move_timer = Timer.new()
	add_child(move_timer)
	move_timer.start(1)
	move_timer.timeout.connect(think)
	
func _process(delta: float) -> void:
	pass

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
		print(next)
		if visited.get(str(next), false):
			continue
		if Grid.grid[next.y][next.x] == Grid.Cell.FOOD:
			return next
		visited[str(next)] = true
		var possible_moves = [Vector2i(-1, 0), Vector2i(1, 0), Vector2i(0, -1), Vector2i(0, 1),
						  Vector2i(-1, -1), Vector2i(1, 1), Vector2i(-1, 1), Vector2i(1, -1)]
		var filtered = possible_moves.filter(is_valid(next))
		for f in filtered:
			q.append(next + f)
	return null
		
func move(direction: Vector2i) -> void:
	coords += direction
	# eat food if there is any
	var new_cell = Grid.grid[coords.y][coords.x]
	if new_cell == Grid.Cell.FOOD:
		for acorn in %Acorns.get_children():
			if acorn.coords == coords:
				acorn.queue_free()
		Grid.score += 1
		Grid.grid[coords.y][coords.x] = Grid.Cell.EMPTY
		
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

extends Node2D

@export var coords: Vector2i

@export var player: int = 1

var t: Tween
var prefix
func move(direction: Vector2i) -> void:
	coords += direction
	t = create_tween()
	t.tween_property(self, "position", coords * 20.0, 0.05)
	t.tween_interval(0.1)
	t.tween_callback(func(): self.t = null)

var Acorns
func _ready() -> void:
	Acorns = get_parent().get_node("%Acorns")
	if player == 1:
		$Cursor.self_modulate = Color.HOT_PINK
		$Indicator.self_modulate = Color.HOT_PINK
		prefix = "p1_"
	else:
		$Cursor.self_modulate = Color.CYAN
		$Indicator.self_modulate = Color.CYAN
		prefix = "p2_"
	$AnimationPlayer.play("flash")

var ACORN_SCENE = preload("res://scenes/acorn.tscn")

var dropping = false
func drop_food():
	if dropping:
		return
	
	if !Grid.is_empty(coords):
		return
	
	$Fall.pitch_scale = randf_range(0.8, 1.2)
	$Fall.play()
	Grid.grid[coords.y][coords.x] = Grid.Cell.PENDING
	
	dropping = true
	
	var acorn = ACORN_SCENE.instantiate()
	acorn.color = $Cursor.self_modulate
	acorn.player = player
	acorn.coords = coords
	Acorns.add_child(acorn)
	
	
	await acorn.dropped
	dropping = false
	
func take_food():
	if dropping:
		return
	if !Grid.is_food(coords):
		return
	var g = Grid.grid[coords.y][coords.x]
	if g == player:
		return
	dropping = true
	Grid.grid[coords.y][coords.x] = Grid.Cell.PENDING
	for acorn in %Acorns.get_children():
			if acorn.coords == coords:
				acorn.player = player
				acorn.color = $Cursor.self_modulate
				acorn.steal()
				$Steal.play()
				await acorn.stolen
	dropping = false
				
func _process(delta: float) -> void:
	if Grid.game_over:
		return
	var direction = Input.get_vector(prefix + "left", prefix + "right", prefix + "up", prefix + "down")
	if t == null:
		move(direction * 1.5)
	if Input.is_action_just_pressed(prefix + "a"):
		drop_food()
	if Input.is_action_just_pressed(prefix + "b"):
		take_food()

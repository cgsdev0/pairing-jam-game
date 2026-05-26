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
	
func _ready() -> void:
	if player == 1:
		$Cursor.self_modulate = Color.RED
		$Indicator.self_modulate = Color.RED
		prefix = "p1_"
	else:
		if Grid.players == 1:
			hide()
		$Cursor.self_modulate = Color.BLUE
		$Indicator.self_modulate = Color.BLUE
		prefix = "p2_"
	$AnimationPlayer.play("flash")

var ACORN_SCENE = preload("res://scenes/acorn.tscn")

var dropping = false
func drop_food():
	if dropping:
		return
	
	if Grid.grid[coords.y][coords.x] == Grid.Cell.FOOD:
		return
	
	dropping = true
	$Cursor.hide()
	$Indicator.show()
	
	var acorn = ACORN_SCENE.instantiate()
	acorn.coords = coords
	%Acorns.add_child(acorn)
	
	
	await acorn.dropped
	$Cursor.show()
	$Indicator.hide()
	dropping = false
	
func _process(delta: float) -> void:
	
	var direction = Input.get_vector(prefix + "left", prefix + "right", prefix + "up", prefix + "down")
	if t == null && !dropping:
		move(direction * 1.5)
	if Input.is_action_just_pressed(prefix + "a"):
		drop_food()

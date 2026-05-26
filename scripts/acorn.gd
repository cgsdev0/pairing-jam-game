extends Node2D

@export var coords: Vector2i

signal dropped

func _ready() -> void:
	position = coords * 20.0
	$Acorn.position.y = -50.0
	var t = create_tween()
	t.tween_property($Acorn, "position", Vector2.ZERO, 1.0)
	t.tween_callback(func(): 
		dropped.emit()
		Grid.grid[coords.y][coords.x] = Grid.Cell.FOOD
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

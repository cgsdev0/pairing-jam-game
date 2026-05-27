extends Node2D

@export var coords: Vector2i

signal dropped
signal stolen

var player

@export var color = Color.WHITE

func _ready() -> void:
	position = coords * 20.0
	$Acorn.position.y = -position.y
	var sm: ShaderMaterial = $Acorn.material
	sm.set_shader_parameter("outline_color", color)
	$Indicator.modulate = color
	var t = create_tween()
	t.tween_property($Acorn, "position", Vector2.ZERO, position.y / 100.0)
	t.tween_callback(func(): 
		dropped.emit()
		Grid.grid[coords.y][coords.x] = player
		$Indicator.hide()
	)
var once = false
func steal():
	if once:
		return
	once = true
	var sm: ShaderMaterial = $Acorn.material
	sm.set_shader_parameter("outline_color", color)
	$Indicator.modulate = color
	# $Indicator.show()
	var t = create_tween()
	t.tween_property($Acorn, "position", Vector2(0.0, -position.y), position.y / 100.0)
	t.tween_callback(func(): 
		stolen.emit()
		Grid.grid[coords.y][coords.x] = player
		$Indicator.hide()
		await RenderingServer.frame_post_draw
		queue_free()
	)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

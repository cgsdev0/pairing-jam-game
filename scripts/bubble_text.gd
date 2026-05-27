extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var t = create_tween()
	t.set_parallel()
	t.tween_property(self, "position", position - Vector2(0, 30), 0.9).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	t.tween_property(self, "modulate", Color.TRANSPARENT, 0.7).set_delay(0.5)
	await t.finished
	queue_free()

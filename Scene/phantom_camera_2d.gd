extends PhantomCamera2D

var entered : bool = false
var tween : Tween
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_area_2d_body_entered(body: Node2D) -> void:
	tween = get_tree().create_tween()
	if not entered:
		tween.tween_property(self, "global_position:y", global_position.y - 600, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	else:
		tween.tween_property(self, "global_position:y", global_position.y + 600, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
		
	entered = !entered

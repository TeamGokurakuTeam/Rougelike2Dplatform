extends Node2D
class_name WaveEffect

@onready var out_side: Sprite2D = $OutSide
@onready var in_side: Sprite2D = $InSide

func _ready() -> void:
	out_side.self_modulate = Color("ffffff82")
	in_side.self_modulate = Color("ffffff82")
	out_side.scale = Vector2.ZERO
	in_side.scale = Vector2.ZERO
	var outside_tween : Tween = create_tween()
	var in_side_tween : Tween = create_tween()
	outside_tween.parallel().tween_property(out_side, "self_modulate", Color("ffffff"), 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	outside_tween.parallel().tween_property(out_side, "scale", Vector2(0.5, 0.5), 0.5).set_trans(Tween.TRANS_CIRC)
	outside_tween.chain()
	outside_tween.parallel().tween_property(out_side, "self_modulate", Color("ffffff00"), 0.7).set_trans(Tween.TRANS_CUBIC)
	
	in_side_tween.parallel().tween_property(out_side, "self_modulate", Color("ffffff"), 0.6).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	in_side_tween.parallel().tween_property(out_side, "scale", Vector2(1.0, 1.0), 0.8).set_trans(Tween.TRANS_CIRC)
	in_side_tween.chain()
	in_side_tween.parallel().tween_property(out_side, "self_modulate", Color("ffffff00"), 1.0).set_trans(Tween.TRANS_CUBIC)
	await in_side_tween.finished
	queue_free()

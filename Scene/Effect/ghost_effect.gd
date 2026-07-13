extends Sprite2D
class_name GhostEffect

var tween_timer : float = 0.75
var animated_sprite_2d : AnimatedSprite2D

func _ready() -> void:
	if animated_sprite_2d != null:
		apply_ghost_effect()

func set_propety(_position : Vector2, _scale : Vector2) -> void:
	self.global_position = _position
	self.scale = _scale

func apply_ghost_effect() -> void:
	texture = animated_sprite_2d.sprite_frames.get_frame_texture(animated_sprite_2d.animation, animated_sprite_2d.frame)
	var tween : Tween = create_tween()
	tween.tween_property(
		self, 
		"self_modulate",
		Color(18.892, 18.892, 18.892, 0.0),
		 tween_timer).set_ease(
			Tween.EASE_OUT
		).set_trans(
			Tween.TRANS_QUINT
			)
	await tween.finished
	
	queue_free()

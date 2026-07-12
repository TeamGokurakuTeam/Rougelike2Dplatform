extends Sprite2D
class_name GhostEffect

func set_property(pos, sca, sprite) -> void:
	position = pos
	scale = sca
	texture = sprite

func _ready() -> void:
	ghost()

func ghost() -> void:
	var tween : Tween = get_parent().create_tween()
	tween.tween_property(self, "self_modulate", Color("ffffff00"), 0.5)
	await tween.finished
	queue_free()

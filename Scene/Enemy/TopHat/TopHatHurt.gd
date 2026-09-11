extends State
class_name TopHatHurt

@export var parent : TopHat
@export var animation_player : AnimationPlayer

var tween : Tween

func Enter() -> void:
	animation_player.play("Hurt")

func Exit() -> void:
	if tween:
		tween.kill()
	parent.sprite.self_modulate = Color("ffffff")

func Update(delta) -> void:
	pass

func Physics_Update(delta) -> void:
	pass

func _on_hurtbox_recieved_damage(damage: float, knockback_dir: Vector2) -> void:
	if randf_range(0.0, 1.0) < 0.5:
		await animation_player.animation_finished
		if tween:
			tween.kill()
		tween = create_tween()
		tween.tween_property(parent.sprite, "self_modulate", Color("c00b00"), 1.0)
		await tween.finished
		StateTransitioned.emit(self, "Attack")
	else:
		await animation_player.animation_finished
		if tween:
			tween.kill()
		tween = create_tween()
		tween.tween_property(parent.sprite, "self_modulate", Color("c00b00"), 1.0)
		await tween.finished
		StateTransitioned.emit(self, "Smash")

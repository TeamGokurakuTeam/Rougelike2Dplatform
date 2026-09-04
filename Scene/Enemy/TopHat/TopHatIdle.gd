extends State
class_name TopHatIdle

@export var parent : TopHat
@export var animation_player : AnimationPlayer
@export var idle_timer : Timer

var tween : Tween

func Enter() -> void:
	if tween:
		tween.kill()
		parent.sprite.self_modulate = Color("ffffff")
	idle_timer.wait_time = randf_range(3.0, 6.0)
	idle_timer.start()
	animation_player.play("Idle")

func Exit() -> void:
	parent.sprite.self_modulate = Color("ffffff")

func Update(delta) -> void:
	pass

func Physics_Update(delta) -> void:
	if not parent.is_on_floor() and not parent.is_fly:
		parent.velocity += parent.get_gravity() * delta

func _on_timer_timeout() -> void:
	if randf_range(0.0, 1.0) <= 0.3:
		if tween:
			tween.kill()
		tween = create_tween()
		tween.tween_property(parent.sprite, "self_modulate", Color("c00b00"), 1.0)
		await tween.finished
		StateTransitioned.emit(self, "Smash")
	else:
		if tween:
			tween.kill()
		tween = create_tween()
		tween.tween_property(parent.sprite, "self_modulate", Color("c00b00"), 1.0)
		await tween.finished
		StateTransitioned.emit(self, "Attack")

func _on_hurtbox_recieved_damage(damage: float, knockback_dir: Vector2) -> void:
	StateTransitioned.emit(self, "Hurt")

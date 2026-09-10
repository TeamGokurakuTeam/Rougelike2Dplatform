extends State
class_name InfectorIdle

@export var parent : Infector
@export var anim_player : AnimationPlayer
@export var timer : Timer

func Enter() -> void:
	anim_player.play("Idle")
	timer.start()

func Exit() -> void:
	pass

func Update(delta) -> void:
	if parent.hp_component.hp <= parent.hp_component.max_hp / 2 and not parent.is_rage:
		parent.is_rage = true
		StateTransitioned.emit(self, "Rage")

func Physics_Update(delta) -> void:
	pass

func _on_idle_timer_timeout() -> void:
	if randi_range(0, 100) <= 100:
		StateTransitioned.emit(self, "Slam")
	else:
		parent.a_rush_effect.emitting = true
		parent.b_rush_effect.emitting = false
		await get_tree().create_timer(1.0).timeout
		StateTransitioned.emit(self, "Rush")

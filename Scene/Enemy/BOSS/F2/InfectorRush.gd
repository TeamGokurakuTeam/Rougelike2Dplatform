extends State
class_name InfectorRush

@export var parent : Infector
@export var anim_player : AnimationPlayer
@export var rush_timer : Timer
@export var ghost_timer : Timer

func Enter() -> void:
	parent.flip_character()
	anim_player.play("Rush")
	rush_timer.start()
	ghost_timer.start()

func Exit() -> void:
	parent.a_rush_effect.emitting = false
	parent.b_rush_effect.emitting = false
	rush_timer.stop()
	ghost_timer.stop()

func Update(delta) -> void:
	pass

func Physics_Update(delta) -> void:
	pass

func _on_ghost_timer_timeout() -> void:
	parent.add_ghost_effect()

func _on_rush_timer_timeout() -> void:
	StateTransitioned.emit(self, "Shoot")

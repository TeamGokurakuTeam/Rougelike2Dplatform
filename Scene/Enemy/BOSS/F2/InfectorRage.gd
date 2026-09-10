extends State
class_name InfectorRage

@export var parent : Infector
@export var anim_player : AnimationPlayer
@export var idle_timer : Timer

func Enter() -> void:
	parent.flip_character()
	anim_player.play("Shout")
	await anim_player.animation_finished
	idle_timer.wait_time = 1.0
	StateTransitioned.emit(self, "Idle")

func Exit() -> void:
	pass

func Update(delta) -> void:
	pass

func Physics_Update(delta) -> void:
	pass

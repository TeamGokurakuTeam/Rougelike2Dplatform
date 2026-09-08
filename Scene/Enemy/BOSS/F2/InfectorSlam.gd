extends State
class_name InfectorSlam

@export var parent : Infector
@export var anim_player : AnimationPlayer

func Enter() -> void:
	parent.flip_character()
	anim_player.play("Slam")
	await anim_player.animation_finished
	StateTransitioned.emit(self, "Idle")

func Exit() -> void:
	parent.flip_character()

func Update(delta) -> void:
	pass

func Physics_Update(delta) -> void:
	pass

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
	if parent.hp_component.hp <= parent.hp_component.max_hp / 2 and not parent.is_rage:
		parent.is_rage = true
		StateTransitioned.emit(self, "Rage")

func Physics_Update(delta) -> void:
	pass

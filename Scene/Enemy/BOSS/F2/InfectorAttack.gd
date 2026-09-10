extends State
class_name InfectorAttack

@export var parent : Infector
@export var anim_player : AnimationPlayer

func Enter() -> void:
	if parent.is_rage:
		for i in 1:
			parent.flip_character()
			parent._rush_attack()
			anim_player.play("Attack")
			await anim_player.animation_finished
	else:
		parent.flip_character()
		anim_player.play("Attack")
		await anim_player.animation_finished
	StateTransitioned.emit(self, "Idle")

func Exit() -> void:
	parent.flip_character()

func Update(delta) -> void:
	if parent.hp_component.hp <= parent.hp_component.max_hp / 3 and not parent.is_rage:
		parent.is_rage = true
		StateTransitioned.emit(self, "Rage")

func Physics_Update(delta) -> void:
	pass

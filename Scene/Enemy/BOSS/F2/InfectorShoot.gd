extends State
class_name InfectorShoot

@export var parent : Infector
@export var anim_player : AnimationPlayer

func Enter() -> void:
	if parent.hp_component.hp <= parent.hp_component.hp / 2:
		for i in 3:
			anim_player.play("Shoot")
	else:
		anim_player.play("Shoot")

func Exit() -> void:
	pass

func Update(delta) -> void:
	pass

func Physics_Update(delta) -> void:
	if anim_player.animation_finished:
		StateTransitioned.emit(self, "Idle")

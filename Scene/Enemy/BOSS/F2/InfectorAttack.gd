extends State
class_name InfectorAttack

@export var parent : Infector
@export var anim_player : AnimationPlayer


func Enter() -> void:
	if parent.is_rage:
		pass
	parent.flip_character()

func Exit() -> void:
	parent.flip_character()

func Update(delta) -> void:
	if parent.hp_component.hp <= parent.hp_component.max_hp / 2 and not parent.is_rage:
		parent.is_rage = true
		StateTransitioned.emit(self, "Rage")

func Physics_Update(delta) -> void:
	pass

extends State
class_name InfectorAttack

@export var parent : Infector
@export var anim_player : AnimationPlayer


func Enter() -> void:
	parent.flip_character()

func Exit() -> void:
	parent.flip_character()

func Update(delta) -> void:
	pass

func Physics_Update(delta) -> void:
	pass

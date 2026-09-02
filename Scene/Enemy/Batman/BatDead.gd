extends State
class_name BatDead

@export var parent : BatMan
@export var anim_player : AnimationPlayer

func Enter() -> void:
	anim_player.play("BatAnim/Death")

func Exit() -> void:
	pass

func Update(delta) -> void:
	pass

func Physics_Update(delta) -> void:
	pass

extends State
class_name SkullWolfDead

@export var parent : SkullWolf
@export var animation_player : AnimationPlayer

func Enter() -> void:
	animation_player.play("Dead")

func Exit() -> void:
	pass

func Update(delta) -> void:
	pass

func Physics_Update(delta) -> void:
	pass

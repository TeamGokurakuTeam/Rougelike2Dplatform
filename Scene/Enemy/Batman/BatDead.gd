extends EnemyState
class_name BatDead

func Enter() -> void:
	anim_player.play("Death")

func Exit() -> void:
	pass

func Update(delta) -> void:
	pass

func Physics_Update(delta) -> void:
	pass

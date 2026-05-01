extends Node2D
class_name HPComponent

@export var max_hp : int = 100
@export var hp : int = 100 : set = _set_hp

signal hp_changed
signal is_dead
signal damaged(amount)  #ダメージを受けた瞬間のシグナル

var is_death_warning : bool = false

func _set_hp(new_hp : int) -> void:
	if hp == 0:
		return

	var old_hp = hp
	hp = clamp(new_hp, 0, max_hp)

	if new_hp < old_hp:
		damaged.emit(old_hp - new_hp)  #HP が減ったときだけ damaged を emit

	hp_changed.emit()

	if hp <= 0:
		is_dead.emit()

func restore_hp() -> void:
	hp = max_hp

extends Node2D
class_name HPComponent

@export var max_hp : float = 100
@export var hp : float = 100 : set = _set_hp #setterは変数を使うときに呼び出される関数

signal hp_changed #hpが変わったときに呼び出される
signal is_dead #自身が死んだ時に呼び出される

var is_death_warning : bool = false

func _set_hp(new_hp : float) -> void:
	if hp == 0:
		return
	hp = clamp(new_hp, 0, max_hp) #hpの最大値、最小値を決めている
	hp_changed.emit()
	if hp <= 0:
		is_dead.emit()

func restore_hp(show_number : bool = false) -> void:
	var diff : float = max_hp - hp
	hp = max_hp #初期化用の関数
	if show_number and diff > 0:
		DamageNumber.display_number(diff, global_position, false, DamageNumber.COLOR_HEAL)

func apply_damage(amount : float, color : Color = DamageNumber.COLOR_DAMAGE_DEFAULT) -> void:
	hp -= amount
	DamageNumber.display_number(amount, global_position, false, color)

func apply_heal(amount : float, color : Color = DamageNumber.COLOR_HEAL) -> void:
	hp += amount
	DamageNumber.display_number(amount, global_position, false, color)

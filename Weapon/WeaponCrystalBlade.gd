extends Weapon
class_name CrystalBlade

func _ready() -> void:
	super._ready()
	animation_player.animation_started.connect(_on_animation_started)

func _on_animation_started(anim_name: StringName) -> void:
	if anim_name == "Attack":
		attack_trigger_modifier()
	if anim_name == "StrongAttack":
		attack_trigger_modifier()

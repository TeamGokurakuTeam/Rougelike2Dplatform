extends BasicProjectile
class_name EffectProjectile

@export var effect_duration : float = 3.0
@export var effect_trigger_damage : float = 1.0
@export var effect_type : Common.EffectType = Common.EffectType.None

func _apply_hit_effect(body: Node) -> void:
	super(body)
	if body.has_method("apply_effect"):
		body.apply_effect(effect_type, effect_trigger_damage, effect_duration)


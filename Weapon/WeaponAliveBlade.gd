extends Weapon
class_name AliveBlade

var strongattack_hit := false

func _ready() -> void:
	super._ready()
	animation_player.animation_started.connect(_on_animation_started)
	animation_player.animation_finished.connect(_on_animation_finished)
	for hitbox in hitboxes:
		hitbox.damage_dealt.connect(_on_hitbox_damage_dealt)

func _on_animation_started(anim_name: StringName) -> void:
	if anim_name == "Attack":
		attack_trigger_modifier()
	if anim_name == "StrongAttack":
		attack_trigger_modifier()
		strongattack_hit = false

func _on_hitbox_damage_dealt(hurtbox: Hurtbox) -> void:
	if animation_player.current_animation == "StrongAttack":
		strongattack_hit = true
		if player and player.hp_component:
			player.hp_component.hp = min(
				player.hp_component.hp + 3,
				player.hp_component.max_hp
			)

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "StrongAttack":
		if not strongattack_hit:
			if player and player.hp_component:
				player.hp_component.hp = max(
					player.hp_component.hp - 3,
					0
				)
		strongattack_hit = false

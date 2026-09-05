extends Weapon
class_name CurseDagger

@onready var hitbox_2: Hitbox = $Root/Hitbox2
@onready var charge_particle_2: GPUParticles2D = $ChargeParticle2

var strongattack_bonus := 0  # Hitbox2の追加ダメージ（上限20）

func _ready() -> void:
	super._ready()
	animation_player.animation_started.connect(_on_animation_started)
	hitbox_2.damage_dealt.connect(_on_hitbox2_damage_dealt)

func _on_animation_started(anim_name: StringName) -> void:
	if anim_name == "Attack":
		attack_trigger_modifier()
	if anim_name == "StrongAttack":
		attack_trigger_modifier()
		hitbox_2.damage_plus = strongattack_bonus

func _on_hitbox2_damage_dealt(hurtbox: Hurtbox) -> void:
	if hurtbox.is_in_group("Enemy"):
		_increase_strongattack_bonus()

func _increase_strongattack_bonus() -> void:
	strongattack_bonus = min(strongattack_bonus + 1, 20)
	hitbox_2.damage_plus = strongattack_bonus
	if strongattack_bonus >= 20:
		charge_particle_2.emitting = true

extends Weapon
class_name TimeBlade

@onready var charge_particle_2: GPUParticles2D = $ChargeParticle2

var strong_attack_count := 0
var strong_attack_queue := 0
var is_playing_multi_strong := false
var block_strongattack := false
var auto_counter_timer : Timer

var counter_speed_bonus := 0.50 # CounterAttack 成功時の速度上昇量
var counter_speed_bonus_max := 2.5 # 上限
var apply_counter_speed_once := false #次のStrongAttackのみ速度上昇

func _ready() -> void:
	super._ready()
	animation_player.animation_started.connect(_on_animation_started)
	auto_counter_timer = Timer.new()
	auto_counter_timer.wait_time = 5.0
	auto_counter_timer.one_shot = false
	auto_counter_timer.timeout.connect(_on_auto_counter_timeout)
	add_child(auto_counter_timer)
	auto_counter_timer.start()

func _process(delta: float) -> void:
	super._process(delta)
	if is_playing_multi_strong:
		auto_counter_timer.stop()
		if not animation_player.is_playing():
			if strong_attack_queue > 0:
				strong_attack_queue -= 1
				attack_trigger_modifier()
				_apply_weapon_strongattack_modifiers()
				animation_player.speed_scale += counter_speed_bonus
				animation_player.play("StrongAttack")
			else:
				is_playing_multi_strong = false
				strong_attack_count = 0
				block_strongattack = true
				charge_particle_2.emitting = false
				charge_particle.emitting = false
				player.counter_timer.stop()
				animation_player.stop()
				animation_player.play("Idle")
				animation_player.speed_scale = 1.0
				apply_counter_speed_once = false
				auto_counter_timer.start()

func _on_animation_started(anim_name: StringName) -> void:
	if anim_name == "Attack":
		# ★ Attack にも修飾子を発動
		attack_trigger_modifier()
		var dmg_mults: AttackDamageMultiplier = calculate_damage_multiplier()
		var speed_mults: AttackSpeedMultiplier = calculate_speed_multiplier()
		for i in hitboxes.size():
			hitboxes[i].damage_plus = dmg_mults.damage_plus
			hitboxes[i].damage_multiplier = dmg_mults.damage_mult
		animation_player.speed_scale = speed_mults.attack_speed_mult
		return
	if anim_name == "StrongAttack":
		if block_strongattack:
			block_strongattack = false
			if strong_attack_count <= 0:
				return
		if strong_attack_count <= 0:
			return
		strong_attack_queue = strong_attack_count - 1
		is_playing_multi_strong = true
		strong_attack_count = 0
		charge_particle_2.emitting = false
		if apply_counter_speed_once:
			animation_player.speed_scale += counter_speed_bonus
			apply_counter_speed_once = false
	elif anim_name == "CounterAttack":
		strong_attack_count += 1
		if strong_attack_count > 5:
			strong_attack_count = 5
		if strong_attack_count == 5:
			charge_particle_2.emitting = true
		apply_counter_speed_once = true
		counter_speed_bonus = min(counter_speed_bonus, counter_speed_bonus_max)

func _on_auto_counter_timeout() -> void:
	if is_playing_multi_strong:
		return
	strong_attack_count += 1
	if strong_attack_count > 5:
		strong_attack_count = 5
	if strong_attack_count == 5:
		charge_particle_2.emitting = true

func _apply_weapon_strongattack_modifiers() -> void:
	var dmg_mults: AttackDamageMultiplier = calculate_damage_multiplier()
	var speed_mults: AttackSpeedMultiplier = calculate_speed_multiplier()
	for i in hitboxes.size():
		hitboxes[i].damage_plus = dmg_mults.charge_damage_plus
		hitboxes[i].damage_multiplier = dmg_mults.charge_damage_mult
	animation_player.speed_scale = speed_mults.charge_attack_speed_mult

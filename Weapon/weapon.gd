extends Node2D
class_name Weapon

const PLAYER_SLASH : PackedScene = preload("uid://bikpq30swfbk1")
const CRITICAL_RATE : float = 1.5
const NORMAL_RATE : float = 1.0

const PLAYER_FALL_SLASH : PackedScene = preload("uid://bjj3tflijfk6o")

const PLAYER_RANGESLASH : PackedScene = preload("uid://dds7cl7iiu2wf")
#アヒル
const DUCK : PackedScene = preload("res://Scene/Player/Projectile/duck.tscn")

@export var resource_id : String

@export_category("ステータス")
@export var cooldown : float = 3.0
@export_enum("火属性", "水属性", "血属性", "呪属性", "聖属性", "無属性") var attribute = "無属性"
@export var durability : float = 100.0
#@export var ability : AbilityResource

@export_category("初期設定")
@export var offset_length : float = 0.0 #発射物が出る時の位置を決める長さ

@onready var modifier_count_timer: Timer = $ModifierCountTimer
@onready var charge_particle: GPUParticles2D = $ChargeParticle
@onready var root: Node2D = $Root
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Root/Sprite2D

var player : Player
var hitboxes : Array[Hitbox] = []
var modifiers_ids : Dictionary[String, int] = {}
var lock_modifiers_ids : Dictionary[String, int] = {}
var mouse_direction : Vector2

#速度上限
var max_speed_scale := 2.5

#使用した修飾子の数
var modifier_use_count: int = 0
#
var fall_slash_cooldown := 0.0


# バウンド設定
var bounce_speed_multiplier := 1.1
var max_speed := 800

# 連撃修飾子
@onready var rampage_timer : Timer = $RampageTimer
const max_rampage_stack : int = 5
var rampage_stack : int = 0

# 剣の不動修飾子
@onready var stillblade_timer : Timer = $StillbladeTimer
const max_stillblade_stack : int = 5
var stillblade_stack : int = 0

# 逆転こそ修飾子
var cumulated_damage : float = 0.0
var is_countering : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	for node in root.get_children():
		if node is Hitbox:
			var hitbox : Hitbox = (node as Hitbox)
			hitboxes.append(node)
			hitbox.damage_dealt.connect(_on_hitbox_damage_dealt)
			hitbox.knockback_source = player
	GameEvents.battle_start.connect(_on_battle_start)
	GameEvents.battle_end.connect(_on_battle_end)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not player.input_enabled:
		return
	if fall_slash_cooldown > 0.0:
		fall_slash_cooldown -= delta
	if Input.is_action_just_pressed("UI_Attack") and not animation_player.is_playing():
		animation_player.play("Charge")
	elif Input.is_action_just_released("UI_Attack"):
		var speed_mults : AttackSpeedMultiplier = calculate_speed_multiplier()
		var dmg_mults: AttackDamageMultiplier = calculate_damage_multiplier()
		if animation_player.is_playing() and player.counter_timer.wait_time > 0 and not player.counter_timer.is_stopped():
			player.counter_timer.stop()
			animation_player.speed_scale = speed_mults.attack_speed_mult
			animation_player.play("CounterAttack")
			is_countering = true
			if player.is_just_dodgeroll:
				player.is_just_dodgeroll = false
				for i in hitboxes.size():
					hitboxes[i].damage_multiplier = CRITICAL_RATE
			await animation_player.animation_finished
			for i in hitboxes.size():
				hitboxes[i].damage_multiplier = NORMAL_RATE
			is_countering = false
		elif animation_player.is_playing() and animation_player.current_animation == "Charge":
			for i in hitboxes.size():
				hitboxes[i].damage_plus = dmg_mults.damage_plus
				hitboxes[i].damage_multiplier = dmg_mults.damage_mult
			animation_player.speed_scale = speed_mults.attack_speed_mult
			animation_player.play("Attack")
		elif charge_particle.emitting:
			for i in hitboxes.size():
				hitboxes[i].damage_plus = dmg_mults.charge_damage_plus
				hitboxes[i].damage_multiplier = dmg_mults.charge_damage_mult
			animation_player.speed_scale = speed_mults.charge_attack_speed_mult
			animation_player.play("StrongAttack")

	mouse_direction = (get_global_mouse_position() - global_position).normalized()
	if not animation_player.is_playing() or animation_player.current_animation == "charge":
		rotation = mouse_direction.angle()
		if scale.y == 1 and mouse_direction.x < 0:
			scale.y = -1
		elif scale.y == -1 and mouse_direction.x > 0:
			scale.y = 1
	#自動攻撃
	if has_modifiers("AutoAttack"):
		if Input.is_action_pressed("UI_Attack"):
			if not animation_player.is_playing():
				var speed_mults : AttackSpeedMultiplier = calculate_speed_multiplier()
				var dmg_mults : AttackDamageMultiplier = calculate_damage_multiplier()
				for i in hitboxes.size():
					hitboxes[i].damage_plus = dmg_mults.damage_plus
					hitboxes[i].damage_multiplier = dmg_mults.damage_mult
				animation_player.speed_scale = speed_mults.attack_speed_mult
				animation_player.play("Attack")
	return

func _is_one_time_modifier(id : String) -> bool:
	return id == "RevolutionResolve" or id == "SacrificialSlash"

func apply_instant_modifier(id : String) -> void:
	# 革命の決心
	if id == "RevolutionResolve":
		if player.mod_resource_ids.size() == 1 and player.hp_component.hp <= 10:
			player.hp_component.restore_hp(true)
	# 玉砕の斬撃
	elif id == "SacrificialSlash":
		sacrificial_slash()

func decrease_modifier(id : String, count : int = 1) -> void:
	if not modifiers_ids.has(id):
		return
	modifiers_ids[id] = max(0, modifiers_ids[id] - count)
	if modifiers_ids[id] <= 0:
		modifiers_ids.erase(id)

func remove_modifier(id : String) -> void:
	if not modifiers_ids.has(id):
		return
	modifiers_ids.erase(id)
	_reset_non_locked_modifier_states()

func add_modifier(id : String, count : int = 1) -> void:
	if _is_one_time_modifier(id):
		apply_instant_modifier(id)
		return

	if modifiers_ids.has(id):
		modifiers_ids[id] += count
	else:
		modifiers_ids[id] = count
	trigger_modifier_when_added(id)

func add_lock_modifier(id : String, count : int = 1) -> void:
	if _is_one_time_modifier(id):
		apply_instant_modifier(id)
		return
	if id in Common.NON_LOCKABLE_MODIFIERS:
		return

	if lock_modifiers_ids.has(id):
		lock_modifiers_ids[id] += count
	else:
		lock_modifiers_ids[id] = count
	trigger_modifier_when_added(id)

func trigger_modifier_when_added(id : String) -> void:
	if id == "Stillblade" and stillblade_timer.is_stopped():
		stillblade_timer.start()
	elif id == "RebirthResolve":
		_try_rebirth_resolve()
	elif id == "Substitute":
		var modifiers : Array = modifiers_ids.keys()
		modifiers.erase("Substitute")
		var modifier_to_delete : String = "Substitute" if modifiers.is_empty() else modifiers.pick_random()
		remove_modifier(modifier_to_delete)

# 修飾子が10以上剣についている時、通常修飾子を全て消す代わりに攻撃力+50・体力全回復し、固定修飾子になる
func _try_rebirth_resolve() -> void:
	# 修飾子が足りない、不発
	if get_unique_modifier_count() < 10:
		return
	modifiers_ids.clear()
	_reset_non_locked_modifier_states()
	add_lock_modifier("RebirthResolve")
	player.hp_component.restore_hp(true)

func _reset_non_locked_modifier_states() -> void:
	if not has_modifiers("Rampage"):
		rampage_stack = 0
		rampage_timer.stop()
	if not has_modifiers("Stillblade"):
		stillblade_stack = 0
		stillblade_timer.stop()
	if not has_modifiers("RevengeSlash"):
		cumulated_damage = 0.0

func reset_modifier() -> void:
	for i in hitboxes.size():
		hitboxes[i].damage_plus = 0.0
		hitboxes[i].damage_multiplier = 1.0
	modifiers_ids.clear()
	_reset_non_locked_modifier_states()

func _physics_process(delta: float) -> void:
	pass

func has_modifiers(name : String):
	return modifiers_ids.has(name) or lock_modifiers_ids.has(name)

func get_modifiers_level(name : String) -> int:
	var sum : int = 0
	if modifiers_ids.has(name):
		sum += modifiers_ids[name]
	if lock_modifiers_ids.has(name):
		sum += lock_modifiers_ids[name]
	return sum
	
	#この関数は同じmodifierの数を返す
	#もし、"同じ数だけあれば大きくする"などの修飾子に使うなら
	#まず、変数にいれてから掛け算すること。

func get_unique_modifier_count() -> int:
	var unique_ids : Dictionary = {}
	for id in modifiers_ids.keys():
		unique_ids[id] = true
	for id in lock_modifiers_ids.keys():
		unique_ids[id] = true
	return unique_ids.size()

func afterimage_slash() -> void:
	var slash := PLAYER_SLASH.instantiate()
	slash.scale *= 0.8
	slash.speed *= 0.8
	var offset := Vector2.RIGHT.rotated(self.rotation) * offset_length
	slash.direction = mouse_direction
	slash.global_position = self.global_position + offset
	if slash.has_method("set_opacity"):
		slash.set_opacity(0.9)
	get_tree().root.add_child(slash)

func leap_forward() -> void: 
	if player == null:
		return
	var leap_power := 300.0 #跳躍の数値
	player.velocity += mouse_direction * leap_power
##破裂し斬撃する(BurstSlasher)
func burst_slash() -> void:
	var slash := PLAYER_SLASH.instantiate()
	slash.direction = mouse_direction.normalized()
	slash.scale *= 0.5
	slash.global_position = global_position
	slash.range_slash_scene = PLAYER_RANGESLASH
	get_tree().root.add_child(slash)
#斬：複製
func fall_slashing() -> void:
	if fall_slash_cooldown > 0.0:
		return
	fall_slash_cooldown = 3.0
	var count: int = 1
	if modifier_use_count >= 10:
		count = 3
	elif modifier_use_count >= 5:
		count = 2
	else:
		count = 1
	count = min(count, 3)
	var range_x = 50
	var range_y_min = -250
	var range_y_max = -100
	var dir = sign(mouse_direction.x)
	if dir == 0:
		dir = 1
	for i in range(count):
		var delay := randf_range(0.0, 0.3)
		var randomspeed := create_tween()
		randomspeed.tween_interval(delay)
		randomspeed.tween_callback(func ():
			var slash := PLAYER_FALL_SLASH.instantiate()
			slash.direction = dir
			slash.damage = 5
			var offset := Vector2(
				randf_range(50, range_x) * dir,
				randf_range(range_y_min, range_y_max)
			)
			slash.global_position = global_position + offset
			slash.knockback_direction = Vector2(dir, 0)
			get_tree().root.add_child(slash)
		)

func bloodletting(direction : Vector2, offset_position_length : float) -> void:
	if player.hp_component.hp > 10:
		var slash : PlayerSlashProjectile = PLAYER_SLASH.instantiate()
		var weapon_rotation : Vector2 = Vector2.RIGHT.rotated(self.rotation) * offset_position_length
		slash.direction = direction
		slash.global_position = self.global_position + weapon_rotation
		if get_modifiers_level("Expanding"):
			slash.scale += Vector2(0.2, 0.2)
		if get_modifiers_level("Swift"):
			slash.speed += 20
		if has_modifiers("Slash_Pierce"):
			slash.set_collision_mask_value(8, false)
		get_tree().root.add_child(slash)
		player.hp_component.apply_damage(1, DamageNumber.COLOR_DAMAGE_SELF) #自傷ダメージ
# アヒル
func slashduck() -> void:
	if randf() < 0.6:
		var duck: DuckProjectile = DUCK.instantiate()
		duck.duck_type = DuckProjectile.DuckType.NORMAL
		duck.should_explode = has_modifiers("Bomb_Duck")
		duck.global_position = player.global_position
		var dir = sign(mouse_direction.x)
		if dir == 0: dir = 1
		var random_x: float = randf_range(100, 350) * dir
		var random_y: float = randf_range(-350, -300)
		duck.velocity = Vector2(random_x, random_y)
		get_tree().root.add_child(duck)

# アヒルバウンス
func bounceduck() -> void:
	var duck: DuckProjectile = DUCK.instantiate()
	duck.duck_type = DuckProjectile.DuckType.BOUNCE
	duck.bounce_speed_multiplier = 1.1
	duck.max_speed = 800
	duck.should_explode = has_modifiers("Bomb_Duck")
	duck.global_position = player.global_position
	var dir = sign(mouse_direction.x)
	if dir == 0: dir = 1
	var random_x: float = randf_range(150, 300) * dir
	var random_y: float = randf_range(-300, -150)
	duck.velocity = Vector2(random_x, random_y)
	get_tree().root.add_child(duck)

func charge_split_slash() -> void:
	if player.hp_component.hp <= 5:
		return
	for i in range(-2, 3):	# [-2, -1, 0, 1, 2]
		var slash : PlayerSlashProjectile = PLAYER_SLASH.instantiate()
		var rotate_angle : float = deg_to_rad(i * 10)
		slash.direction = mouse_direction.normalized().rotated(rotate_angle)
		slash.global_position = global_position
		get_tree().current_scene.add_child(slash)
	player.hp_component.apply_damage(5, DamageNumber.COLOR_DAMAGE_SELF)

# 玉砕の斬撃
func sacrificial_slash() -> void:
	var modifier_count : int = get_unique_modifier_count()
	if modifier_count <= 0:
		return
	const projectile_count : int = 8
	modifiers_ids.clear()
	_reset_non_locked_modifier_states()
	for i in modifier_count:
		var random_angle_offset : float = randf_range(0, 360)
		for j in projectile_count:
			var slash : PlayerSlashProjectile = PLAYER_SLASH.instantiate()
			var rotate_angle : float = deg_to_rad(j * 360. / projectile_count + random_angle_offset)
			# 常に貫通する
			slash.set_collision_mask_value(8, false)
			slash.direction = Vector2.RIGHT.rotated(rotate_angle)
			slash.global_position = global_position
			get_tree().current_scene.add_child(slash)
			slash.damage = 5
		await get_tree().create_timer(0.3).timeout

func start_modifier_timer() -> void:
	modifier_count_timer.start()

func dash() -> void:
	player.player_dash()

func _on_modifier_count_timer_timeout() -> void:
	reset_modifier()

func _on_battle_start() -> void:
	modifier_count_timer.paused = false

func _on_battle_end() -> void:
	modifier_count_timer.paused = true

class AttackDamageMultiplier:
	var damage_plus : float = 0.0
	var charge_damage_plus : float = 0.0
	var damage_mult : float = 1.0			# ダメージの倍率
	var charge_damage_mult : float = 1.0	# チャージダメージの倍率

class AttackSpeedMultiplier:
	var charge_speed_mult : float = 1.0			# チャージ速度
	var attack_speed_mult : float = 1.0			# 攻撃速度
	var charge_attack_speed_mult : float = 1.0	# チャージ攻撃速度

func calculate_damage_multiplier() -> AttackDamageMultiplier:
	var mults: AttackDamageMultiplier = AttackDamageMultiplier.new()

	# 反撃な
	if has_modifiers("Reversal"):
		var hp_percent := float(player.hp_component.hp) / float(player.hp_component.max_hp)
		# 10% 20% 30%... に変換する
		var gated_hp : float = ceil(hp_percent * 10.0) / 10.0 
		# HPが10%時2倍ダメージ
		var reversal_mult: float = 1.0 + (1.0 - gated_hp) / 0.9
		mults.damage_mult *= reversal_mult
		mults.charge_damage_mult *= reversal_mult

	# 衰退し加速する
	if has_modifiers("DampingSpeedUp"):
		var level : int = get_modifiers_level("DampingSpeedUp")
		mults.damage_mult *= 0.9 ** level
		mults.charge_damage_mult *= 0.9 ** level

	# 重撃
	if has_modifiers("HeavyStrike"):
		var level : int = get_modifiers_level("HeavyStrike")
		mults.charge_damage_mult *= (1 + 0.2 * level)

	# 連撃
	if has_modifiers("Rampage"):
		mults.damage_mult *= (1 + 0.2 * rampage_stack)
		mults.charge_damage_mult *= (1 + 0.2 * rampage_stack)

	if has_modifiers("Stillblade"):
		mults.damage_plus += 1 * stillblade_stack
		mults.charge_damage_plus += 1 * stillblade_stack
		stillblade_stack = 0
		stillblade_timer.start()

	# 転生の覚悟
	if has_modifiers("RebirthResolve"):
		mults.damage_plus += 50
		mults.charge_damage_plus += 50

	#残影な
	if has_modifiers("Afterimage"):
		mults.damage_mult *= 0.9
		mults.charge_damage_mult *= 0.9
	return mults

func calculate_speed_multiplier() -> AttackSpeedMultiplier:
	var mults: AttackSpeedMultiplier = AttackSpeedMultiplier.new()

	# 衰退し加速する
	if has_modifiers("DampingSpeedUp"):
		var level : int = get_modifiers_level("DampingSpeedUp")
		mults.attack_speed_mult *= (1 + 0.1 * level)
		mults.charge_attack_speed_mult *= (1 + 0.1 * level)
	
	# 重撃
	if has_modifiers("HeavyStrike"):
		var level : int = get_modifiers_level("HeavyStrike")
		mults.attack_speed_mult *= 0.8 ** level

	mults.attack_speed_mult = min(mults.attack_speed_mult, max_speed_scale)
	mults.charge_attack_speed_mult = min(mults.charge_attack_speed_mult, max_speed_scale)

	return mults

func _on_hitbox_damage_dealt(hurtbox : Hurtbox) -> void:
	assert(rampage_timer != null, "rampage_timer is null")
	rampage_stack = min(rampage_stack + 1, max_rampage_stack)
	rampage_timer.start()
	if is_countering:
		trigger_modifier_when_counter(hurtbox)

func _on_rampage_timer_timeout() -> void:
	rampage_stack = 0

func _on_stillblade_timer_timeout() -> void:
	stillblade_stack = min(stillblade_stack + 1, max_stillblade_stack)
	if stillblade_stack >= max_stillblade_stack:
		stillblade_timer.stop()

func trigger_modifier_when_attack() -> void:
	modifier_use_count += 1

	if has_modifiers("Bloodletting"):
		bloodletting(mouse_direction, offset_length)
	#跳躍(Leap)
	if has_modifiers("Leap"):
		leap_forward()
	#残影な(Afterimage)
	if has_modifiers("Afterimage"):
		afterimage_slash()
	#破裂し斬撃する(BurstSlasher)
	if has_modifiers("Burstslasher"):
		burst_slash()
	#斬：複製
	if has_modifiers("FallSlashing"):
		fall_slashing()
	#アヒル
	if has_modifiers("Slash_Duck"):
		slashduck()
	#アヒルバウンス
	if has_modifiers("Bounce_Duck"):
		bounceduck()
	#アヒル爆弾

func trigger_modifier_when_strong_attack() -> void:
	if has_modifiers("ChargeSplitSlash"):
		charge_split_slash()

func trigger_modifier_when_receive_damage(damage : float) -> void:
	if has_modifiers("RevengeSlash"):
		cumulated_damage += damage

func trigger_modifier_when_counter(hurtbox : Hurtbox) -> void:
	if has_modifiers("RevengeSlash") and cumulated_damage > 0.0:
		var release_damage : float = cumulated_damage / 3.0
		cumulated_damage -= release_damage
		hurtbox.apply_extra_damage(release_damage)

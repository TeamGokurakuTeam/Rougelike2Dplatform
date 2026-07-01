extends Node2D
class_name Weapon

const PLAYER_SLASH : PackedScene = preload("uid://bikpq30swfbk1")
const CRITICAL_RATE : float = 1.5
const NORMAL_RATE : float = 1.0

const PLAYER_FALL_SLASH : PackedScene = preload("uid://bjj3tflijfk6o")

const PLAYER_RANGESLASH : PackedScene = preload("uid://dds7cl7iiu2wf")


@export var resource_id : String

@export_category("ステータス")
@export var cooldown : float = 3.0
@export_enum("火属性", "水属性", "血属性", "呪属性", "聖属性", "無属性") var attribute = "無属性"
@export var durability : float = 100
#@export var ability : AbilityResource

@export_category("初期設定")
@export var offset_length : float = 0 #発射物が出る時の位置を決める長さ

@onready var modifier_count_timer: Timer = $ModifierCountTimer
@onready var charge_particle: GPUParticles2D = $ChargeParticle
@onready var root: Node2D = $Root
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Root/Sprite2D

var player : Player
var hitboxes : Array[Hitbox] = []
var modifiers_ids : Dictionary[String, int] = {}
var mouse_direction : Vector2
#自動攻撃
var auto_attack_speed_buff_active := false
var auto_attack_original_speed := 1.0
var base_speed_scale = 1.0 #現在の速度

#速度上限
var max_speed_scale := 2.5
#
var original_multipliers: Array[float] = []
#
var original_acceleration := 0.0

var base_stats : Array[HitboxStat] = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for node in root.get_children():
		if node is Hitbox:
			var hitbox : Hitbox = (node as Hitbox)
			hitboxes.append(node)
			base_stats.append(HitboxStat.new_stat(hitbox.damage, hitbox.knockback_force))
	player = get_tree().get_first_node_in_group("Player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("UI_Attack") and not animation_player.is_playing():
		animation_player.play("Charge")
	elif Input.is_action_just_released("UI_Attack"):
		if animation_player.is_playing() and player.counter_timer.wait_time > 0 and not player.counter_timer.is_stopped():
			player.counter_timer.stop()
			animation_player.play("CounterAttack")
			if player.is_just_dodgeroll:
				player.is_just_dodgeroll = false
				for i in hitboxes.size():
					hitboxes[i].damage_multiplier = CRITICAL_RATE
			await animation_player.animation_finished
			for i in hitboxes.size():
				hitboxes[i].damage_multiplier = NORMAL_RATE
				
		elif animation_player.is_playing() and animation_player.current_animation == "Charge":
			animation_player.play("Attack")
		elif charge_particle.emitting:	
			animation_player.play("StrongAttack")
	
	mouse_direction = (get_global_mouse_position() - global_position).normalized()
	
	if not animation_player.is_playing() or animation_player.current_animation == "charge":
		rotation = mouse_direction.angle()
		if scale.y == 1 and mouse_direction.x < 0:
			scale.y = -1
		elif scale.y == -1 and mouse_direction.x > 0:
			scale.y = 1
	#自動攻撃
	if modifiers_ids.has("AutoAttack"):
		if Input.is_action_pressed("UI_Attack"):
			if not animation_player.is_playing():
				animation_player.play("Attack")
				await animation_player.animation_started
				base_speed_scale = animation_player.speed_scale
				_try_auto_attack_speed_buff()
	return


#func move(mouse_direction: Vector2) -> void:
	#if ranged_weapon:
		#rotation_degrees = rad_to_deg(mouse_direction.angle()) + rotation_offset
	#else:
		#if not animation_player.is_playing() or animation_player.current_animation == "charge":
			#rotation = mouse_direction.angle()
			#hitbox.knockback_direction = mouse_direction
			#if scale.y == 1 and mouse_direction.x < 0:
				#scale.y = -1
			#elif scale.y == -1 and mouse_direction.x > 0:
				#scale.y = 1

func add_modifier(id : String, count : int = 1) -> void:
	if modifiers_ids.has(id):
		modifiers_ids[id] += count
	else:
		modifiers_ids[id] = count
	#ModifierLibrary.apply_sharp(self)

func reset_modifier() -> void:
	for i in hitboxes.size():
		hitboxes[i].damage = base_stats[i].damage
		hitboxes[i].knockback_force = base_stats[i].knockback_force
	modifiers_ids.clear()

func _physics_process(delta: float) -> void:
	pass


func attack_trigger_modifier() -> void:
	
	if modifiers_ids.has("Bloodletting"):
		bloodletting(mouse_direction, offset_length)
#跳躍(Leap)
	if modifiers_ids.has("Leap"):
		leap_forward()
#残影な(Afterimage)
	if modifiers_ids.has("Afterimage"):
		afterimage_slash()
#反撃な（Reversal）
	if modifiers_ids.has("Reversal"):
		reversal_up()
#破裂し斬撃する(BurstSlasher)
	if modifiers_ids.has("Burstslasher"):
		burst_slash()
#斬：複製
	if modifiers_ids.has("FallSlashing"):
		fall_slashing()
#攻撃速度ビルド
	if modifiers_ids.has("DampingSpeedUp"):
		damping_speedup(mouse_direction,offset_length)


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
#反撃な
func reversal_up() -> void:
	var current_hp := player.hp_component.hp
	var max_hp := player.hp_component.max_hp
	current_hp = max(current_hp, 1)
	var multiplier := pow(float(max_hp) / float(current_hp), 1.5)
	for i in hitboxes.size():
		var new_damage := base_stats[i].damage * multiplier
		hitboxes[i].damage = base_stats[i].damage * multiplier
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
	var count = 3
	var range_x = 50
	var range_y_min = -250
	var range_y_max = -100
	var dir = sign(mouse_direction.x)
	if dir == 0:
		dir = 1
	for i in count:
		var delay := randf_range(0.0, 0.3)
		var randomspeed := create_tween()
		randomspeed.tween_interval(delay)
		randomspeed.tween_callback(func ():
			var slash := PLAYER_FALL_SLASH.instantiate()
			slash.direction = dir
			slash.damage =3
			var offset := Vector2(randf_range(50, range_x) * dir,randf_range(range_y_min, range_y_max))
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
		if modifiers_ids.has("Expanding"):
			slash.scale += Vector2(0.1, 0.1)
		if modifiers_ids.has("Swift"):
			slash.speed += 10
		if modifiers_ids.has("Slash_Pierce"):
			slash.set_collision_mask_value(8, false)
		get_tree().root.add_child(slash)
		DamageNumber.display_number(2, global_position, false, Color("6f0000ff"))
		player.hp_component.hp -= 2 #2は自傷ダメージ
#攻撃速度ビルド
func damping_speedup(direction: Vector2, offset_Speed_Up: float) -> void:
	var target_speed = 2.5#速度
	animation_player.speed_scale = min(target_speed, max_speed_scale)
	for i in range(hitboxes.size()):
		var new_damage := 0.0
		var min_damage := 1.0
		new_damage = max(new_damage, min_damage)
		if randf() < 0.5:
			new_damage = 0.0
		else:
			new_damage = 1.0
		hitboxes[i].damage = new_damage
#自動攻撃
func _try_auto_attack_speed_buff() -> void:
	if auto_attack_speed_buff_active:
		return
	if randf() < 0.3:
		_start_auto_attack_speed_buff()
#自動攻撃
func _start_auto_attack_speed_buff() -> void:
	auto_attack_speed_buff_active = true
	auto_attack_original_speed = animation_player.speed_scale
	var auto_speed = 1.3
	var damping_speed = 0.0
	if modifiers_ids.has("DampingSpeedUp"):
		damping_speed = 2.5
	var raw_speed = auto_speed + damping_speed
	var final_speed = min(raw_speed, max_speed_scale)
	animation_player.speed_scale = final_speed
	var need_save := false
	if modifiers_ids.has("Speedingexceed") or modifiers_ids.has("SpeedingMoveExceed"):
		need_save = true
	if need_save:
		original_multipliers.clear()
		for i in range(hitboxes.size()):
			original_multipliers.append(hitboxes[i].damage_multiplier)
	if modifiers_ids.has("Speedingexceed"):
		var exceed = raw_speed - max_speed_scale
		if exceed > 0:
			_add_speed_exceed_damage(exceed)
	if modifiers_ids.has("SpeedingMoveExceed"):
		var exceed = raw_speed - max_speed_scale
		if exceed > 0:
			original_acceleration = player.current_acceleration
			_add_speed_move_exceed(exceed)
	var timer := Timer.new()
	timer.wait_time = 2.0
	timer.one_shot = true
	add_child(timer)
	timer.timeout.connect(func():
		animation_player.speed_scale = auto_attack_original_speed
		auto_attack_speed_buff_active = false
		if original_multipliers.size() == hitboxes.size():
			for i in range(hitboxes.size()):
				hitboxes[i].damage_multiplier = original_multipliers[i]
		original_multipliers.clear()
		if original_acceleration != 0.0:
			player.current_acceleration = original_acceleration
			original_acceleration = 0.0
		timer.queue_free())
	timer.start()

#超過速度な
func _add_speed_exceed_damage(exceed: float) -> void:
	for i in range(hitboxes.size()):
		hitboxes[i].damage_multiplier += exceed
		print("超過",exceed)
#???
func _add_speed_move_exceed(exceed:float) -> void:
	if exceed > 0:
		var add_speed = exceed * 20
		player.current_acceleration += add_speed

func start_modifier_timer() -> void:
	modifier_count_timer.start()

func dash() -> void:
	player.player_dash()

func _on_modifier_count_timer_timeout() -> void:
	reset_modifier()

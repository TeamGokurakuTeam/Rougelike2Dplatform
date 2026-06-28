extends Node2D
class_name Weapon

const PLAYER_SLASH : PackedScene = preload("uid://bikpq30swfbk1")
const CRITICAL_RATE : float = 1.5
const NORMAL_RATE : float = 1.0

const PLAYER_RANGESLASH : PackedScene = preload("res://Scene/Player/Projectile/range_slash.tscn")

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
var lock_modifiers_ids : Dictionary[String, int] = {}
var mouse_direction : Vector2

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
func decrease_modifier(id : String, count : int = 1) -> void:
	if modifiers_ids.has(id):
		modifiers_ids[id] = max(0, modifiers_ids[id] - count)

func add_modifier(id : String, count : int = 1) -> void:
	if modifiers_ids.has(id):
		modifiers_ids[id] += count
	else:
		modifiers_ids[id] = count
	#ModifierLibrary.apply_sharp(self)

func add_lock_modifier(id : String, count : int = 1) -> void:
	if lock_modifiers_ids.has(id):
		lock_modifiers_ids[id] += count
	else:
		lock_modifiers_ids[id] = count

func reset_modifier() -> void:
	for i in hitboxes.size():
		hitboxes[i].damage = base_stats[i].damage
		hitboxes[i].knockback_force = base_stats[i].knockback_force
	modifiers_ids.clear()

func _physics_process(delta: float) -> void:
	pass

func has_modifiers(name : String):
	return modifiers_ids.has(name) or lock_modifiers_ids.has(name)

func attack_trigger_modifier() -> void:
	if has_modifiers("Bloodletting"):
		bloodletting(mouse_direction, offset_length)
#跳躍(Leap)
	if has_modifiers("Leap"):
		leap_forward()
#残影な(Afterimage)
	if has_modifiers("Afterimage"):
		afterimage_slash()
#反撃な（Reversal）
	if has_modifiers("Reversal"):
		reversal_up()
#破裂し斬撃する(BurstSlasher)
	if has_modifiers("Burstslasher"):
		burst_slash()
	
func get_modifiers_level(name : String) -> bool:
	var sum : int = 0
	if modifiers_ids.has(name):
		sum += modifiers_ids[name]
	if lock_modifiers_ids.has(name):
		sum += lock_modifiers_ids[name]
	return sum

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
		if modifiers_ids.has("Slash_Pierce"):
			slash.set_collision_mask_value(8, false)
		get_tree().root.add_child(slash)
		DamageNumber.display_number(2, global_position, false, Color("6f0000ff"))
		player.hp_component.hp -= 2 #2は自傷ダメージ

func start_modifier_timer() -> void:
	modifier_count_timer.start()

func dash() -> void:
	player.player_dash()

func _on_modifier_count_timer_timeout() -> void:
	reset_modifier()

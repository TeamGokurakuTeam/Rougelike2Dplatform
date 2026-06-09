extends Character
class_name Player

const GHOST_EFFECT = preload("uid://bbh4yarpd37co")

@onready var parry_effect: GPUParticles2D = $Parry
@onready var ghost_timer: Timer = $GhostTimer
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var counter_timer: Timer = $CounterDetector/CounterTimer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var inventory: Node2D = $Inventory
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hurtbox_collision: CollisionShape2D = $Hurtbox/CollisionShape2D2
@onready var counter_collision: CollisionShape2D = $CounterDetector/CollisionShape2D
@onready var hurtbox: Hurtbox = $Hurtbox

@export var max_jump_pressed_frame : int = 5

@export_category("プレイヤーステータス")
@export var defense_power : float = 10
@export var critical_chance : float = .0
@export var critical_damage : float = .0
@export var luck : float = .0
@export var dodgeroll_acceleration : int = 60
@export var dodgeroll_time : float = 0.5

var weapon_resource_ids : Array[String] = []
#アイテムとしての武器の配列

var mod_resource_ids : Array[String] = []
#アイテムとしてのmodifierの配列

var current_weapon : int = -1
var current_modifier : int = -1 : set = _set_current_modifier
#現在選択している修飾子の場所

var coyote_time_activated : bool = false
var fall_through_time := 0.25
var fall_timer := 0.0
#ジャンプのジャストタイミング
var jump_pressed_frame : int = 0

var is_dodgeroll : bool = false
var dodgeroll_dir : Vector2 = Vector2.ZERO
var ghost_effect : GhostEffect

signal pickup_item(player : Player)
signal pickup_modifier(player : Player)
signal applied_modifier(player : Player)

func _process(delta: float) -> void:
	var mouse_direction : Vector2 = (get_global_mouse_position() - global_position).normalized()
	#マウスの方向はグローバル位置のマウスポジション - 自分のグローバル位置を正規化した方向
	if mouse_direction.x > 0 and animated_sprite_2d.flip_h:
		#マウスの方向が右側にあったら
		animated_sprite_2d.flip_h = false
	elif mouse_direction.x < 0 and not animated_sprite_2d.flip_h:
		#マウスの方向が左側にあったら
		animated_sprite_2d.flip_h = true

func _physics_process(delta: float) -> void:
	super(delta)
	_get_input()
	if fall_timer > 0:
		fall_timer -= delta
		if fall_timer <= 0:
			set_collision_mask_value(1, true)
	var was_on_floor : bool = is_on_floor()
	if was_on_floor && !is_on_floor():
		coyote_timer.start()
	if jump_pressed_frame > 0:
		jump_pressed_frame -= 1
	
	#歩き
	if abs(velocity.x) > 0.8:
		animation_player.play("Walk")
	else:
		animation_player.play("Idle")

func external_bounce_jump(power: float) -> void:
	velocity.y = -power

func _get_input() -> void:
	#移動方向の初期化
	move_direction = Vector2.ZERO
	#get_axisで方向を求めている
	move_direction.x = Input.get_axis(&"UI_left",&"UI_right") #横移動の入力
	
	if abs(move_direction.x) > 0 and Input.is_action_just_pressed("UI_DodgeRoll") and not is_dodgeroll:
		is_dodgeroll = true
		ghost_timer.start()
		counter_timer.start()
		_counter_switch()
		dodgeroll_dir.x = sign(move_direction.x)
		current_acceleration = dodgeroll_acceleration
		await get_tree().create_timer(dodgeroll_time).timeout
		is_dodgeroll = false
		hurtbox.monitoring = true
		current_acceleration = acceleration
		
	if is_dodgeroll:
		var tween : Tween = create_tween()
		tween.tween_property(
			self,
			"dodgeroll_acceleration",
			dodgeroll_acceleration,
			dodgeroll_time).set_ease(
				Tween.EASE_IN
				).set_trans(
					Tween.TRANS_EXPO
					)
		move_direction.x = dodgeroll_dir.x
	else:
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = jump_velocity
		if Input.is_action_just_pressed("UI_Down"):
			fall_timer = fall_through_time
			set_collision_mask_value(1, false)
		ghost_timer.stop()
	
	if is_on_floor():
		if coyote_time_activated:
			coyote_time_activated = false
			coyote_timer.stop()
	else:
		if !coyote_time_activated:
			coyote_timer.start()
			coyote_time_activated = true
		
		#ui_acceptに移動させるし、書いたやつを殺す
		if Input.is_action_just_pressed("UI_Jump") and (!coyote_timer.is_stopped() or is_on_floor()):
			jump_pressed_frame = max_jump_pressed_frame
			velocity.y = jump_velocity
			coyote_timer.stop()
			coyote_time_activated = true
	
	if Input.is_action_just_pressed("UI_Apply"):
		if weapon_resource_ids.size() <= 0 and inventory.get_child_count() <= 0:
			return
		var weapon : Weapon = inventory.get_child(current_weapon)
		weapon.add_modifier(mod_resource_ids[current_modifier])
		#weapon.modifiers_ids.append(mod_resource_ids[current_modifier])
		mod_resource_ids.remove_at(current_modifier)
		current_modifier -= 1
		pickup_modifier.emit(self)
		weapon.start_modifier_timer()
	
	#region プロトタイプ完了後奇麗にする
	for i in range(5):
		if Input.is_action_just_pressed(&"UI_%d" % (i + 1)):
			var prev_weapon = current_weapon
			current_weapon = i
			if current_weapon >= weapon_resource_ids.size() or current_weapon < 0:
				current_weapon = prev_weapon
				return
			update_weapon()
			break
	#endregion

func update_weapon() -> void:
	if current_weapon == -1:
		for node in inventory.get_children():
			node.queue_free()
	var res : ResourceItem = GlobalResourceLoader.item_cache[weapon_resource_ids[current_weapon]]
	var weapon : Weapon = res.WeaponScene.instantiate()
	for node in inventory.get_children():
		node.queue_free()
	inventory.call_deferred("add_child", weapon)
	pickup_item.emit(self)
	applied_modifier.emit.call_deferred(self)

func update_modifier() -> void:
	current_modifier += 1
	print("current_modifier : ", current_modifier)
	pickup_modifier.emit(self)

func merge_weapon(target_res_id : String) -> void:
	var target_res : ResourceItem = GlobalResourceLoader.item_cache[target_res_id]
	var count : int = weapon_resource_ids.count(target_res.Id)
	if count >= 2 and target_res.MergeResultWeaponId != "":
		current_weapon = 0
		weapon_resource_ids.erase(target_res.Id)
		weapon_resource_ids.erase(target_res.Id)
		weapon_resource_ids.append(target_res.MergeResultWeaponId)
		merge_weapon(target_res.MergeResultWeaponId)

func _dodge_roll_effect() -> void:
	ghost_effect = GHOST_EFFECT.instantiate()
	ghost_effect.animated_sprite_2d = self.animated_sprite_2d
	ghost_effect.set_propety(animated_sprite_2d.global_position, animated_sprite_2d.scale)
	get_tree().current_scene.add_child(ghost_effect)

func _counter_switch() -> void:
	counter_collision.disabled = !counter_collision.disabled

func _on_ghost_timer_timeout() -> void:
	_dodge_roll_effect()

func _on_counter_timer_timeout() -> void:
	_counter_switch()

func _on_hp_component_is_dead() -> void:
	self.queue_free()

func _set_current_modifier(new_value : int) -> void:
	if mod_resource_ids.size() <= 0:
		current_modifier = 0
		return
	current_modifier = new_value % mod_resource_ids.size()
	if current_modifier < 0:
		current_modifier += mod_resource_ids.size()

func _on_counter_detector_area_entered(area: Area2D) -> void:
	if area is Hitbox:
		parry_effect.emitting = true
		hurtbox.monitoring = false

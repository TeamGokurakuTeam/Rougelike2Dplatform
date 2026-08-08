extends Character
class_name Player

const GHOST_EFFECT = preload("uid://bbh4yarpd37co")

@onready var parry_effect: GPUParticles2D = $Parry
@onready var ghost_timer: Timer = $GhostTimer
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var dodge_roll_cool_down_timer: Timer = $DodgeRollCoolDownTimer #ドッジロール再使用までの時間
@onready var dodge_rolling_timer: Timer = $DodgeRollingTimer #ドッジロールしている時の時間
@onready var counter_timer: Timer = $CounterTimer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var inventory: Node2D = $Inventory
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hurtbox_collision: CollisionShape2D = $Hurtbox/CollisionShape2D2
@onready var hurtbox: Hurtbox = $Hurtbox

@export var max_jump_pressed_frame : int = 5
@export_category("プレイヤーステータス")
@export var defense_power : float = 10
@export var critical_chance : float = .0
@export var critical_damage : float = .0
@export var luck : float = .0
@export var dash_acceleration : int = 80
@export var dodgeroll_acceleration : int = 60
@export var dodgeroll_time : float = 0.5
@export var just_dodgeroll_time : float = 0.09

var weapon_resource_ids : Array[String] = []
var mod_resource_ids : Array[String] = []
var current_weapon : int = -1
var current_modifier : int = -1 : set = _set_current_modifier
var coyote_time_activated : bool = false
var fall_through_time : float = 0.5
var fall_timer : float = 0.0
#ジャンプのジャストタイミング
var jump_pressed_frame : int = 0
#Fan
var external_velocity : Vector2 = Vector2.ZERO
var external_friction := 500.0
#慣性
var floor_motion: Vector2 = Vector2.ZERO
#凍結ダメージ
var dot_damage_per_second: float = 0.0
var dot_timer: float = 0.0 
var original_color: Color = Color.WHITE 
var is_dodgeroll : bool = false
var dodgeroll_dir : Vector2 = Vector2.ZERO
var is_just_dodgeroll : bool = false
#
var deadly_ready : bool = false
var ghost_effect : GhostEffect
var weapon : Weapon

signal pickup_item(player : Player)
signal modifier_updated(player : Player)
signal applied_modifier(player : Player)
signal modifier_picked_up(mod_res : ModifierResource)

func _process(delta: float) -> void:
	var mouse_direction : Vector2 = (get_global_mouse_position() - global_position).normalized()
	if mouse_direction.x > 0 and animated_sprite_2d.flip_h:
		animated_sprite_2d.flip_h = false
	elif mouse_direction.x < 0 and not animated_sprite_2d.flip_h:
		#マウスの方向が左側にあったら
		animated_sprite_2d.flip_h = true

func _physics_process(delta: float) -> void:
	#慣性
	_get_input()
	super(delta)
	if floor_motion != Vector2.ZERO:
		global_position += floor_motion
		global_position.y += 0
	floor_motion = Vector2.ZERO
	var was_on_floor : bool = is_on_floor()
	if was_on_floor && !is_on_floor():
		coyote_timer.start()
	if jump_pressed_frame > 0:
		jump_pressed_frame -= 1
	#歩き
	if is_dodgeroll:
		animation_player.play("DodgeRoll")
	elif abs(velocity.x) > 0.8:
		animation_player.play("Walk")
	else:
		animation_player.play("Idle")
	#Fan
	velocity += external_velocity
	external_velocity = external_velocity.move_toward(Vector2.ZERO, external_friction * delta)
	#凍結ダメージ
	if dot_timer > 0:
		dot_timer -= delta
		hp_component.hp -= dot_damage_per_second * delta
		if dot_timer <= 0:
			animated_sprite_2d.modulate = original_color

func external_bounce_jump(power: float) -> void:
	velocity.y = -power
#Fan
func add_external_force(force: Vector2) -> void:
	external_velocity += force
#凍結
func apply_dot(dps: float, duration: float) -> void:
	dot_damage_per_second = dps
	dot_timer = duration
	original_color = animated_sprite_2d.modulate
	animated_sprite_2d.modulate = Color(0.2,0.8,2.0)

func _get_input() -> void:
	move_direction = Vector2.ZERO
	move_direction.x = Input.get_axis(&"UI_left", &"UI_right")
	if abs(move_direction.x) > 0 and Input.is_action_just_pressed("UI_DodgeRoll") and not is_dodgeroll:
		if dodge_roll_cool_down_timer.time_left <= 0.0:
			is_dodgeroll = true
			ghost_timer.start()
			dodge_rolling_timer.start()
			dodgeroll_dir.x = sign(move_direction.x)
			current_acceleration = dodgeroll_acceleration
	if is_dodgeroll:
		var tween: Tween = create_tween()
		tween.tween_property(self, "dodgeroll_acceleration", dodgeroll_acceleration, dodgeroll_time) \
			.set_ease(Tween.EASE_IN) \
			.set_trans(Tween.TRANS_EXPO)
		move_direction.x = dodgeroll_dir.x
	else:
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = jump_velocity

		ghost_timer.stop()
	if is_on_floor():
		if coyote_time_activated:
			coyote_time_activated = false
			coyote_timer.stop()
	else:
		if !coyote_time_activated:
			coyote_timer.start()
			coyote_time_activated = true
		if Input.is_action_just_pressed("UI_Jump") and (!coyote_timer.is_stopped() or is_on_floor()):
			jump_pressed_frame = max_jump_pressed_frame
			velocity.y = jump_velocity
			coyote_timer.stop()
			coyote_time_activated = true
	if Input.is_action_just_pressed("UI_Apply"):
		if weapon_resource_ids.size() <= 0 and inventory.get_child_count() <= 0:
			return
		weapon = inventory.get_child(current_weapon)
		weapon.add_modifier(mod_resource_ids[current_modifier])
		mod_resource_ids.remove_at(current_modifier)
		current_modifier -= 1
		modifier_updated.emit(self)
		weapon.start_modifier_timer()
	for i in range(5):
		if Input.is_action_just_pressed(&"UI_%d" % (i + 1)):
			var prev_weapon = current_weapon
			current_weapon = i
			if current_weapon >= weapon_resource_ids.size() or current_weapon < 0:
				current_weapon = prev_weapon
				return
			update_weapon()
			break

func update_weapon() -> void:
	if current_weapon == -1:
		for node in inventory.get_children():
			node.queue_free()
	var res : ResourceItem = GlobalResourceLoader.item_cache[weapon_resource_ids[current_weapon]]
	weapon = res.WeaponScene.instantiate()
	for node in inventory.get_children():
		node.queue_free()
	inventory.call_deferred("add_child", weapon)
	pickup_item.emit(self)
	applied_modifier.emit.call_deferred(self)

func update_modifier() -> void:
	current_modifier += 1
	modifier_updated.emit(self)

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

func player_dash() -> void:
	current_acceleration = dash_acceleration
	await get_tree().create_timer(0.4).timeout
	current_acceleration = acceleration

#Spikeダメージ
func take_damage(amount : float) -> void:
	hp_component.hp -= amount

#region setter
func _set_current_modifier(new_value : int) -> void:
	if mod_resource_ids.size() <= 0:
		current_modifier = 0
		return
	current_modifier = new_value % mod_resource_ids.size()
	if current_modifier < 0:
		current_modifier += mod_resource_ids.size()
#endregion

#region signal
func _on_hurtbox_recieved_damage(damage: float, knockback_dir: Vector2) -> void:
	if not is_dodgeroll:
		hp_component.hp -= damage
		DamageNumber.display_number(damage, global_position, false, Color("ff0000"))
	elif dodge_rolling_timer.time_left >= (dodge_rolling_timer.wait_time - just_dodgeroll_time):
		parry_effect.emitting = true
		is_just_dodgeroll = true
		#致命的な
		deadly_ready = true
		counter_timer.start()
	elif dodge_roll_cool_down_timer.is_stopped():
		dodge_roll_cool_down_timer.start()
		counter_timer.start()

func _on_dodge_rolling_timer_timeout() -> void:
	is_dodgeroll = false
	current_acceleration = acceleration

func _on_ghost_timer_timeout() -> void:
	_dodge_roll_effect()

func _on_hp_component_is_dead() -> void:
	self.queue_free()
#endregion

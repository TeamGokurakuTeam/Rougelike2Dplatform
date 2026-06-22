extends Character
class_name Player

@onready var coyote_timer: Timer = $CoyoteTimer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var inventory: Node2D = $Inventory
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export  var max_jump_pressed_frame : int = 5

@export_category("プレイヤーステータス")
@export var defense_power : float = 10
@export var critical_chance : float = .0
@export var critical_damage : float = .0
@export var luck : float = .0


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

#Fan
var external_velocity : Vector2 = Vector2.ZERO
var external_friction := 500.0
#慣性
var floor_motion: Vector2 = Vector2.ZERO
#凍結ダメージ
var dot_damage_per_second: float = 0.0
var dot_timer: float = 0.0 
var original_color: Color = Color.WHITE 



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
	#慣性
	_get_input()
	super(delta)
	if floor_motion != Vector2.ZERO:
		global_position += floor_motion
	floor_motion = Vector2.ZERO
	
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
	if abs(velocity.x) > 0.1:
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
	#移動方向の初期化
	move_direction = Vector2.ZERO
	#get_axisで方向を求めている
	move_direction.x = Input.get_axis(&"UI_left",&"UI_right") #横移動の入力
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity
	if Input.is_action_just_pressed("UI_Down"):
		fall_timer = fall_through_time
		set_collision_mask_value(1, false)
	
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
		if weapon_resource_ids.size() < 0 and inventory.get_child_count() <= 0:
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

#Spikeダメージ
func take_damage(amount : float) -> void:
	hp_component.hp -= amount

func _on_hp_component_is_dead() -> void:
	self.queue_free()

func _set_current_modifier(new_value : int) -> void:
	if mod_resource_ids.size() <= 0:
		current_modifier = 0
		return
	current_modifier = new_value % mod_resource_ids.size()
	if current_modifier < 0:
		current_modifier += mod_resource_ids.size()

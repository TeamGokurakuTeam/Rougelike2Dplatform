extends Character
class_name Player

var resource_ids : Array[String] = []

@onready var coyote_timer: Timer = $CoyoteTimer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var inventory: Node2D = $Inventory

var current_weapon : int = -1
var coyote_time_activated : bool = false


signal pickup_item(player : Player)

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
	
	var was_on_floor : bool = is_on_floor()
	if was_on_floor && !is_on_floor():
		coyote_timer.start()
		

func _get_input() -> void:
	#移動方向の初期化
	move_direction = Vector2.ZERO
	#get_axisで方向を求めている
	move_direction.x = Input.get_axis(&"UI_left",&"UI_right") #横移動の入力
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity
	
	if is_on_floor():
		if coyote_time_activated:
			coyote_time_activated = false
			coyote_timer.stop()
	else:
		if !coyote_time_activated:
			coyote_timer.start()
			coyote_time_activated = true
	
	if Input.is_action_just_pressed("UI_Jump") and (!coyote_timer.is_stopped() or is_on_floor()):
		velocity.y = jump_velocity
		coyote_timer.stop()
		coyote_time_activated = true
		
	#region プロトタイプ完了後奇麗にする
	for i in range(5):
		if Input.is_action_just_pressed(&"UI_%d" % (i + 1)):
			var prev_weapon = current_weapon
			current_weapon = i
			if current_weapon >= resource_ids.size() or current_weapon < 0:
				current_weapon = prev_weapon
				return
			update_weapon()
			break
	#endregion
	

func update_weapon() -> void:
	if current_weapon == -1:
		for node in inventory.get_children():
			node.queue_free()
	var res : ResourceItem = GlobalResourceLoader.item_cache[resource_ids[current_weapon]]
	var weapon : Weapon = res.WeaponScene.instantiate()
	for node in inventory.get_children():
		node.queue_free()
	inventory.call_deferred("add_child", weapon)
	pickup_item.emit(self)

func merge_weapon(target_res_id : String) -> void:
	var target_res : ResourceItem = GlobalResourceLoader.item_cache[target_res_id]
	var count : int = resource_ids.count(target_res.Id)
	if count >= 2 and target_res.MergeResultWeaponId != "":
		current_weapon = 0
		resource_ids.erase(target_res.Id)
		resource_ids.erase(target_res.Id)
		resource_ids.append(target_res.MergeResultWeaponId)
		merge_weapon(target_res.MergeResultWeaponId)

func _on_hp_component_is_dead() -> void:
	self.queue_free()

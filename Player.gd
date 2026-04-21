extends Character
class_name Player

const JUMP_VELOCITY : float = -900
var resource_ids : Array[String] = []

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var inventory: Node2D = $Inventory

signal pickup_item

func _process(delta: float) -> void:
	var mouse_direction : Vector2 = (get_global_mouse_position() - global_position).normalized()
	#マウスの方向はグローバル位置のマウスポジション - 自分のグローバル位置を正規化した方向
	
	if mouse_direction.x > 0 and sprite_2d.flip_h:
		#マウスの方向が右側にあったら
		sprite_2d.flip_h = false
	elif mouse_direction.x < 0 and not sprite_2d.flip_h:
		#マウスの方向が左側にあったら
		sprite_2d.flip_h = true

func _physics_process(delta: float) -> void:
	super(delta)
	_get_input()
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		

func _get_input() -> void:
	#移動方向の初期化
	move_direction = Vector2.ZERO
	#get_axisで方向を求めている
	move_direction.x = Input.get_axis(&"UI_left",&"UI_right") #横移動の入力
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_pressed("UI_1"):
		var res : ResourceItem = GlobalResourceLoader.item_cache[resource_ids[0]]
		var weapon : Weapon = res.WeaponScene.instantiate()
		for node in inventory.get_children():
			node.queue_free()
		inventory.add_child(weapon)
	if Input.is_action_just_pressed("UI_2"):
		var res : ResourceItem = GlobalResourceLoader.item_cache[resource_ids[1]]
		var weapon : Weapon = res.WeaponScene.instantiate()
		for node in inventory.get_children():
			node.queue_free()
		inventory.add_child(weapon)
	if Input.is_action_just_pressed("UI_3"):
		var res : ResourceItem = GlobalResourceLoader.item_cache[resource_ids[2]]
		var weapon : Weapon = res.WeaponScene.instantiate()
		for node in inventory.get_children():
			node.queue_free()
		inventory.add_child(weapon)
	

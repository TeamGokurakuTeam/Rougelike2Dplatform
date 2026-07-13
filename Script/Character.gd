extends CharacterBody2D
class_name Character

@export var friction : float = .15 ##摩擦力または抵抗力

@export var jump_velocity : float = -600
@export var max_speed : float = 200 
@export var hp_component: HPComponent
@export var acceleration : int = 30 #加速度
@export var is_fly : bool = false

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var current_acceleration : int = 0
var move_direction : Vector2 = Vector2.ZERO #移動する方向
var main_game_node : MainGame

var is_damaged : bool = false

func _ready() -> void:
	current_acceleration = acceleration

func _physics_process(delta: float) -> void:
	velocity.x = lerp(velocity.x, .0, friction)
	if not is_on_floor() and not is_fly:
		velocity += get_gravity() * delta
	move()
	move_and_slide()
	#lerpは線形補間、移動速度を補間している

func move() -> void:
	move_direction = move_direction.normalized() #移動する方向を0~1(正規化)している
	velocity.x += move_direction.x * current_acceleration #動く方向にスピードをかけている
	
	#velocity = velocity.limit_length(max_speed) #最大速度の設定
	
	#なぜ正規化するのかというと移動速度の統一と方向の安定をさせなければいけないから
	#Player.gdにもmove()を使っている

func knockback(dir : Vector2) -> void:
	velocity += dir

func _on_hurtbox_recieved_damage(damage: float, knockback_dir: Vector2) -> void:
	hp_component.hp -= damage
	DamageNumber.display_number(damage, global_position, false, Color("ffffff"))

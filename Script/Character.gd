extends CharacterBody2D
class_name Character

@export var friction : float = .15 ##摩擦力または抵抗力

@export var jump_velocity : float = -600
@export var max_speed : float = 200 
@export var hp_component: HPComponent
@export var acceleration : int = 30 #加速度
@export var is_fly : bool = false
@export var knockback_immune : bool = false
@export var knockback_friction : float = 500.0

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var current_acceleration : int = 0
var move_direction : Vector2 = Vector2.ZERO #移動する方向
var main_game_node : MainGame
var external_velocity : Vector2 = Vector2.ZERO

var is_damaged : bool = false
var room : Room

func _ready() -> void:
	current_acceleration = acceleration

func _physics_process(delta: float) -> void:
	velocity.x = lerp(velocity.x, .0, friction)
	if not is_on_floor() and not is_fly:
		velocity += get_gravity() * delta
	velocity += external_velocity
	external_velocity = external_velocity.move_toward(Vector2.ZERO, knockback_friction * delta)
	move()
	move_and_slide()
	#lerpは線形補間、移動速度を補間している

func move() -> void:
	move_direction = move_direction.normalized() #移動する方向を0~1(正規化)している
	velocity.x += move_direction.x * current_acceleration #動く方向にスピードをかけている

	#velocity = velocity.limit_length(max_speed) #最大速度の設定

	#なぜ正規化するのかというと移動速度の統一と方向の安定をさせなければいけないから
	#Player.gdにもmove()を使っている

func add_external_force(force : Vector2) -> void:
	external_velocity += force

func apply_knockback(dir : Vector2) -> void:
	if knockback_immune:
		return
	add_external_force(dir)

func _on_hurtbox_recieved_damage(damage: float, knockback_dir: Vector2) -> void:
	hp_component.apply_damage(damage, DamageNumber.COLOR_DAMAGE_DEFAULT)
	apply_knockback(knockback_dir)

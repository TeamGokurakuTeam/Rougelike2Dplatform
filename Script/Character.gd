extends CharacterBody2D
class_name Character

const FRICTION : float = 0.15 ##摩擦力または抵抗力

@export var max_speed : float = 200 
@export var speed : float = 20 : set = _set_speed
@export var hp_component: HPComponent

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var move_direction : Vector2 = Vector2.ZERO #移動する方向
var accerelation : int = 20 #加速度

func _physics_process(delta: float) -> void:
	velocity = lerp(velocity, Vector2.ZERO, FRICTION)
	move()
	move_and_slide()
	#lerpは線形補間、移動速度を補間している

func move() -> void:
	move_direction = move_direction.normalized() #移動する方向を0~1(正規化)している
	velocity += move_direction * accerelation #動く方向にスピードをかけている
	#velocity = velocity.limit_length(max_speed) #最大速度の設定
	
	#なぜ正規化するのかというと移動速度の統一と方向の安定をさせなければいけないから
	#Player.gdにもmove()を使っている

func knockback(dir : Vector2) -> void:
	velocity += dir

func _set_speed(new_speed : float) -> void:
	speed = clamp(new_speed, 0, max_speed) #set_hpと同じ

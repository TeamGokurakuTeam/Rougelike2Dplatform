extends Area2D
class_name BasicProjectile

@export var life_time: float = 3.0
@export var damage: float = 5.0
@export var facing: Vector2 = Vector2.RIGHT
@export var speed: float = 300.0

var velocity : Vector2 = Vector2.RIGHT

func setup(facing_: Vector2, speed_: float) -> void:
	facing = facing_
	speed = speed_

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	velocity = facing.normalized() * speed
	global_position += velocity * delta
	rotation = velocity.angle()
	life_time -= delta
	if life_time <= 0:
		queue_free()

func _apply_hit_effect(body : Node) -> void:
	if body is Player:
		if body.has_method("take_damage"):
			body.take_damage(damage)

func _on_body_entered(body : Node) -> void:
	_apply_hit_effect(body)
	queue_free()

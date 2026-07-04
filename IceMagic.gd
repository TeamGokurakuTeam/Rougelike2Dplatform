extends Area2D
class_name IceMagic

@export var life_time: float = 3.0
@export var damage: float = 5.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	global_position += velocity * delta
	if velocity.x > 0:
		animation_player.play("Right")
	else:
		animation_player.play("Left")
	#上下
	if velocity.y > 0:
		animation_player.play("Up")
	else:
		animation_player.play("Down")
	#斜め
	if velocity.x > 0 || velocity.y > 0:
		animation_player.play("Slanted_DownRight")
	else:
		animation_player.play("Slanted_UpLeft")
	if velocity.x > -0 || velocity.y > 0:
		animation_player.play("Slanted_UpRight")
	if velocity.x > 0 || velocity.y > -0:
		animation_player.play("Slanted_DownLeft")
	life_time -= delta
	if life_time <= 0:
		queue_free()

func _on_body_entered(body : Node) -> void:
	if body.is_in_group("Player"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
		if body.has_method("apply_dot"):
			body.apply_dot(2,2.0) #(ダメージ、時間)
	queue_free()

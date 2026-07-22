extends CharacterBody2D
class_name GolemArm

@export var speed : float = 100
@export var acceleration : float = 10

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var is_enter : bool = false

func _ready() -> void:
	animation_player.play("Shoot")

func _physics_process(delta: float) -> void:
	var player : Player = get_tree().get_first_node_in_group("Player")
	if player == null or is_enter:
		return
	var target_velocity : Vector2 = (player.global_position - self.global_position).normalized() * speed
	var vectorB : Vector2 = target_velocity - velocity
	print(vectorB)
	velocity += vectorB * acceleration * delta
	velocity = velocity.limit_length(speed)
	self.global_rotation = velocity.angle()
	move_and_slide()

func _on_hitbox_body_entered(body: Node2D) -> void:
	is_enter = true
	animation_player.play("Boom")
	await animation_player.animation_finished
	self.queue_free()

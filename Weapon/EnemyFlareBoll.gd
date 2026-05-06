extends Area2D

@export var animation_player: AnimationPlayer

var player: Node2D
var speed: float = 300.0
var velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	player = get_tree().current_scene.find_child("Player", true, false)
	if player:
		var dir = (player.global_position - global_position).normalized()
		velocity = dir * speed
	connect("area_entered", Callable(self, "_on_area_entered"))
	_auto_destroy()
	if animation_player:
		animation_player.play("FlareBoll")

func _process(delta: float) -> void:
	position += velocity * delta

func _on_area_entered(area: Area2D) -> void:
	queue_free()

func _auto_destroy() -> void:
	await get_tree().create_timer(3.0).timeout
	if is_inside_tree():
		queue_free()

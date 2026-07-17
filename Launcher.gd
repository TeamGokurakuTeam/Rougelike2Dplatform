extends Node2D
class_name Launcher

@export var fire_interval : float = 1.0
@export var projectile_scene: PackedScene
@export var shoot_direction: Vector2 = Vector2.RIGHT
@export var projectile_speed: float = 300.0
@export var projectile_facing: Vector2 = Vector2.RIGHT
@onready var fire_point: Marker2D = $FirePoint
@onready var timer: Timer = $FireTimer

func _ready() -> void:
	timer.wait_time = fire_interval
	timer.timeout.connect(_shoot)
	timer.start()

func _shoot() -> void:
	if projectile_scene == null:
		return
	var bullet = projectile_scene.instantiate()
	bullet.global_position = fire_point.global_position
	if "facing" in bullet:
		bullet.facing = projectile_facing.normalized()
	if "velocity" in bullet:
		bullet.velocity = shoot_direction.normalized() * projectile_speed
	get_tree().current_scene.add_child(bullet)

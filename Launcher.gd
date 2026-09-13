extends ComponentHost
class_name Launcher

@export var fire_interval : float = 1.0
@export var projectile_scene: PackedScene
@export var shoot_direction: Vector2 = Vector2.RIGHT
@export var projectile_speed: float = 300.0
@onready var fire_point: Marker2D = $FirePoint
@onready var timer: Timer = $FireTimer

func _ready() -> void:
	super()
	timer.wait_time = fire_interval
	timer.timeout.connect(_shoot)
	timer.start()

func _shoot() -> void:
	if projectile_scene == null:
		return
	var bullet : Node = projectile_scene.instantiate()
	if bullet is BasicProjectile:
		bullet.setup(shoot_direction, projectile_speed)
	bullet.global_position = fire_point.global_position
	get_tree().current_scene.add_child(bullet)

func _on_trap_component_trap_enabled() -> void:
	timer.start()

func _on_trap_component_trap_disabled() -> void:
	timer.stop()

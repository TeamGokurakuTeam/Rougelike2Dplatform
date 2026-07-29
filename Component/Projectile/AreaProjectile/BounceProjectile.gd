extends AreaProjectile
class_name BounceProjectile

@export var enable_bounce : bool = false
@export var bounce_speed_multiplier : float = 1.1
@export var max_speed : float = 800.0
@export var bounce_ray_length : float = 10.0

var velocity : Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if not _should_process_physics():
		return
	_apply_gravity(delta)
	_move(delta)
	if enable_bounce:
		_check_bounce()

## 物理を停止させたい場合にこれを継承先でオーバーライドする
func _should_process_physics() -> bool:
	return true

func _apply_gravity(delta: float) -> void:
	velocity.y += gravity * delta

func _move(delta: float) -> void:
	global_position += velocity * delta

func _check_bounce() -> void:
	var space_state := get_world_2d().direct_space_state
	var params := PhysicsRayQueryParameters2D.create(
		global_position,
		global_position + velocity.normalized() * bounce_ray_length
	)
	var result := space_state.intersect_ray(params)
	if result.size() > 0:
		_bounce(result.normal)

func _bounce(normal: Vector2) -> void:
	velocity = velocity.bounce(normal)
	velocity *= bounce_speed_multiplier
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed
	

extends CharaProjectile
class_name HedoroGear

@export var enable_spin : bool = false
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var spin_speed : float = 315.0

func _ready() -> void:
	super()
	is_gravity = true
	animation_player.play("Start")

func _physics_process(delta: float) -> void:
	if is_gravity:
		var gravity_value = ProjectSettings.get_setting("physics/2d/default_gravity")
		velocity.y += gravity_value * delta
 
	if constant_speed:
		_clamp_to_max_speed()
 
	sprite.rotation_degrees += direction.x * spin_speed * delta
	move_and_slide()
 
	if enable_bounce:
		_handle_bounce()

func _on_timer_timeout() -> void:
	is_gravity = false
	animation_player.play("End")
	speed = 0
	await animation_player.animation_finished
	destory()

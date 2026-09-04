extends Enemy
class_name TopHat

const FIRE_BALL = preload("uid://bmyrk7jftdcqv")

@export var jump_height_offset : float = 120.0
@export var jump_peak_offset : float = 150.0
@export var jump_duration : float = 0.6
@export var hover_duration : float = 0.3
@export var drop_speed : float = 900.0

var bullet_num : int = 5
var texture : Texture2D
var center : Vector2

var is_jump_attack : bool = false
var is_slamming : bool = false

func _ready() -> void:
	texture = sprite.sprite_frames.get_frame_texture(sprite.animation, sprite.frame)
	center = (texture.get_size()) / 2

func _physics_process(delta : float) -> void:
	pass

func jump_slam_attack(target : Player) -> void:
	if is_jump_attack or is_slamming:
		return
	
	is_jump_attack = true
	velocity = Vector2.ZERO
	
	var hover_position : Vector2 = target.global_position + Vector2(0, -jump_height_offset)
	await _jump_to(hover_position)
	await get_tree().create_timer(hover_duration).timeout
	
	is_jump_attack = false
	is_slamming = true
	velocity = Vector2(0, drop_speed)

func _jump_to(target_position : Vector2) -> void:
	var start_position: Vector2 = global_position
	var peak_y: float = min(start_position.y, target_position.y) - jump_peak_offset
	
	var x_tween := create_tween()
	x_tween.tween_property(self, "global_position:x", target_position.x, jump_duration)
 
	var y_tween := create_tween()
	y_tween.tween_property(self, "global_position:y", peak_y, jump_duration * 0.5) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	y_tween.tween_property(self, "global_position:y", target_position.y, jump_duration * 0.5) \
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	
	await y_tween.finished

func on_slam_landed() -> void:
	main_game_node.main_camera.shake_fade = 2
	main_game_node.main_camera.apply_shake(6)

func _spawn_bullet(pos : Vector2, angle : float):
	var bullet : FireBall = FIRE_BALL.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = pos
	bullet.fire_angle = angle
	main_game_node.main_camera.shake_fade = 2
	main_game_node.main_camera.apply_shake(8)

func set_target(target_pos : Vector2) -> void:
	navigation_agent.target_position = target_pos

func move_toward_player() -> void:
	if navigation_agent.is_navigation_finished():
		return
	
	var next_pos : Vector2 = navigation_agent.get_next_path_position()
	var dir : Vector2 = (next_pos - global_position).normalized()
	
	velocity.x = dir.x * max_speed
	
	if dir.y < -0.9 and is_on_floor():
		velocity.y = jump_velocity

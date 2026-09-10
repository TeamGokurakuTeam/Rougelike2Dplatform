extends Enemy
class_name Infector

const HEDORO_GEAR = preload("uid://02rhrcwex5jr")
const GHOST_EFFECT = preload("uid://dris5yp7e3utg")
const HEDORO_BULLET = preload("uid://dts67twvgxnr5")
const HEDORO_SLIME = preload("uid://cuhgb0dmmo2dk")

@onready var marker: Marker2D = $Marker2D
@onready var slam_collision: CollisionShape2D = $Hitboxes/Hitbox/CollisionShape2D2
@onready var ghost_timer: Timer = $GhostTimer
@onready var slam_effect: GPUParticles2D = $SlamEffect
@onready var a_rush_effect: GPUParticles2D = $Rush
@onready var b_rush_effect: GPUParticles2D = $Rush2
@onready var shout: GPUParticles2D = $Shout
@onready var spawn_bullet_pos: Marker2D = $SpawnBulletPos
@onready var boss_enemy_spawn_point: Marker2D = $BossEnemySpawnPoint
@onready var spawner_animation_player: AnimationPlayer = $BossEnemySpawnPoint/AnimationPlayer

var is_rage : bool = false
var rush_speed : float = max_speed
var enemy_count : int = 0

func _ready() -> void:
	a_rush_effect.emitting = false
	b_rush_effect.emitting = false
	player_dir()

func _physics_process(delta: float) -> void:
	if not animation_player.is_playing():
		flip_character()
	velocity.x = lerp(velocity.x, .0, friction)
	if not is_on_floor() and not is_fly:
		velocity += get_gravity() * delta
	move()
	move_and_slide()

func flip_character() -> void:
	if player_dir() > 0 and not sprite.flip_h:
		sprite.flip_h = true
		sprite.offset.x = 16.0
		slam_collision.scale = -Vector2(1.5, 1.5)
		slam_effect.position.x = 70
		shout.position.x = 73.0
		spawn_bullet_pos.position.x = 82.0
		boss_enemy_spawn_point.position.x = 92.0
	elif player_dir() < 0 and sprite.flip_h:
		sprite.flip_h = false
		sprite.offset.x = -8.0
		slam_collision.scale = Vector2(1.5, 1.5)
		slam_effect.position.x = -70
		shout.position.x = -50.0
		spawn_bullet_pos.position.x = -71.0
		boss_enemy_spawn_point.position.x = -92.0

func shoot() -> void:
	var gear : HedoroGear = HEDORO_GEAR.instantiate()
	gear.speed = randf_range(150, 200)
	gear.direction = Vector2(player_dir(), randf_range(-1.0, 0))
	gear.bounce_speed_multi = randf_range(0.1, 0.4)
	get_tree().current_scene.add_child(gear)
	gear.global_position = marker.global_position

func player_dir() -> float:
	var player : Player
	player = get_tree().get_first_node_in_group("Player")
	if player == null:
		return 0
	navigation_agent.target_position = player.global_position
	if navigation_agent.is_navigation_finished():
		return 0
	var next_pos : Vector2 =  navigation_agent.get_next_path_position()
	var player_dir_x : float = sign(next_pos.x - global_position.x)
	
	return player_dir_x

func add_ghost_effect() -> void:
	var ghost : GhostEffect = GHOST_EFFECT.instantiate()
	ghost.set_propety(position, sprite.scale)
	ghost.z_index = 3
	get_tree().current_scene.add_child(ghost)

func _on_ghost_timer_timeout() -> void:
	add_ghost_effect()

func _spawn_bullet(pos : Vector2, angle : float):
	var bullet : CharaProjectile = HEDORO_BULLET.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = pos
	bullet.fire_angle = angle
	bullet.speed = randf_range(300, 700)
	main_game_node.main_camera.shake_fade = 4
	main_game_node.main_camera.apply_shake(4)

func shout_camera_effect() -> void:
	main_game_node.main_camera.shake_fade = 1
	main_game_node.main_camera.apply_shake(20)

func spawn_slam_custom_bullet(num : int) -> void:
	for i in num:
		var angle : float = randf_range(-45, 45)
		_spawn_bullet(spawn_bullet_pos.global_position, angle)
		await get_tree().create_timer(0.01).timeout

func _rush_attack() -> void:
	var tween : Tween = get_parent().create_tween()
	ghost_timer.start()
	var target : Player = get_tree().get_first_node_in_group("Player")
	
	if target == null:
		return
	
	flip_character()
	var dir : Vector2 = global_position.direction_to(target.global_position)
	tween.tween_property(self, "velocity:x", dir.x * rush_speed, 0.5).set_trans(tween.TRANS_BOUNCE).set_ease(tween.EASE_OUT)
	tween.tween_property(self, "velocity", Vector2.ZERO, 0.1)
	await tween.finished
	ghost_timer.stop()

func attack_summon() -> void:
	if enemy_count >= 6:
		return
	spawner_animation_player.play("Summon")

func _slime_anim_summon() -> void:
	if enemy_count >= 6:
		return
	var hedoro_slime : HedoroSlime = HEDORO_SLIME.instantiate()
	get_tree().current_scene.add_child(hedoro_slime)
	hedoro_slime.global_position = boss_enemy_spawn_point.global_position
	hedoro_slime.hp_component.hp = hedoro_slime.hp_component.max_hp / 2
	hedoro_slime.hp_component.is_dead.connect(_on_slime_is_dead)
	enemy_count += 1

func _on_slime_is_dead() -> void:
	enemy_count -= 1

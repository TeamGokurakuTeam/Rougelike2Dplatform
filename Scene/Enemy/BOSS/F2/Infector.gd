extends Enemy
class_name Infector

@onready var marker: Marker2D = $Marker2D
@onready var slam_collision: CollisionShape2D = $Hitboxes/Hitbox/CollisionShape2D2
@onready var ghost_timer: Timer = $GhostTimer
@onready var slam_effect: GPUParticles2D = $SlamEffect

const HEDORO_GEAR = preload("uid://02rhrcwex5jr")
const GHOST_EFFECT = preload("uid://dris5yp7e3utg")

func _ready() -> void:
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
	elif player_dir() < 0 and sprite.flip_h:
		sprite.flip_h = false
		sprite.offset.x = -8.0
		slam_collision.scale = Vector2(1.5, 1.5)
		slam_effect.position.x = -70

func shoot() -> void:
	var gear : HedoroGear = HEDORO_GEAR.instantiate()
	get_tree().current_scene.add_child(gear)
	gear.global_position = marker.global_position

func player_dir() -> float:
	var player : Player = get_tree().get_nodes_in_group("Player")[0]
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
	get_tree().current_scene.add_child(ghost)

func _on_ghost_timer_timeout() -> void:
	add_ghost_effect()

func _rush_attack() -> void:
	var tween : Tween = get_parent().create_tween()
	ghost_timer.start()
	var target : Player = get_tree().get_first_node_in_group("Player")
	
	if target == null:
		return
	
	flip_character()
	var rush_speed : float = max_speed + 50
	var dir : Vector2 = global_position.direction_to(target.global_position)
	tween.tween_property(self, "velocity:x", dir.x * rush_speed, 0.5).set_trans(tween.TRANS_BOUNCE).set_ease(tween.EASE_OUT)
	tween.tween_property(self, "velocity", Vector2.ZERO, 0.1)
	await tween.finished
	ghost_timer.stop()

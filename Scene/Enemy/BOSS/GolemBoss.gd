extends Enemy
class_name GolemBoss

const GOLEM_ARM = preload("uid://sa838rue6n5a")
const GOLEM_ATTACK_EFFECT = preload("uid://blkm73mbwl7so")
const GOLEM_RAGE_ATTACK_EFFECT = preload("uid://cw8yc8sr720na")
const GOLEM_STONES = preload("uid://dn7if2gxj3bea")

@onready var root_node: Node2D = $RootNode
@onready var marker_2d: Marker2D = $RootNode/Marker2D
@onready var rock_shoot_2: AudioStreamPlayer2D = $Audio/RockShoot2
@onready var attack_pos: Marker2D = $AttackPos

@export var dash_speed : float = 200
@export var can_move : bool = true

var max_degree : float = 30
var angle_acceleration : float = 30
var player : Player

var is_rage : bool = false

func _ready() -> void:
	if get_tree().get_node_count_in_group("Player"):
		player = get_tree().get_nodes_in_group("Player")[0]

func _physics_process(delta: float) -> void:
	super(delta)

func GolemFlyRotate(delta : float) -> void:
	var target_degree : float = velocity.x * 0.05
	target_degree = clamp(target_degree, -max_degree, max_degree)
	rotation = lerp_angle(
		rotation,
		deg_to_rad(target_degree),
		angle_acceleration * delta
		)

func Dash() -> void:
	if player != null:
		navigation_agent.target_position = player.global_position
		if navigation_agent.is_navigation_finished():
			return
		var next_pos : Vector2 =  navigation_agent.get_next_path_position()
		var player_dir_x : float = sign(next_pos.x - global_position.x)
		velocity.x += player_dir_x * dash_speed

func Shoot() -> void:
	var arm : GolemArm = GOLEM_ARM.instantiate()
	add_child(arm)
	arm.global_position = marker_2d.global_position

func attack_effect() -> void:
	var effect : GolemAttackEffect = GOLEM_ATTACK_EFFECT.instantiate()
	get_tree().current_scene.add_child(effect)
	effect.position = Vector2(attack_pos.global_position.x, attack_pos.global_position.y - 20)

func _rage_attack() -> void:
	var golem_stones : GolemStones = GOLEM_STONES.instantiate()
	get_tree().current_scene.add_child(golem_stones)
	golem_stones.global_position = self.global_position

#---test-----------
func move_toward_player() -> void:
	if navigation_agent.is_navigation_finished():
		return
	
	var next_pos : Vector2 = navigation_agent.get_next_path_position()
	var dir : Vector2 = (next_pos - global_position).normalized()
	
	velocity.x = dir.x * max_speed
	
	if dir.y < -0.9 and is_on_floor():
		velocity.y = jump_velocity

func set_target(target_pos : Vector2) -> void:
	navigation_agent.target_position = target_pos
#------------------

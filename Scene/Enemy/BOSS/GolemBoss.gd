extends Enemy
class_name GolemBoss

@export var dash_speed : float = 200
@export var can_move : bool = true

var max_degree : float = 30
var angle_acceleration : float = 30
var player : Player

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

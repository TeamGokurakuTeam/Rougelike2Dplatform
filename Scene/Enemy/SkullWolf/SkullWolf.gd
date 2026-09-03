extends Enemy
class_name SkullWolf

@export var dash_speed : float = 100

var player : Player
var prev_state : String = ""

func Dash() -> void:
	player = get_tree().get_first_node_in_group("Player")
	navigation_agent.target_position = player.global_position
	if navigation_agent.is_navigation_finished():
		return
	var next_pos : Vector2 =  navigation_agent.get_next_path_position()
	var player_dir_x : float = sign(next_pos.x - global_position.x)
	velocity.x += player_dir_x * dash_speed

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

func _on_hp_component_is_dead() -> void:
	killed_drop_item()
	killed_drop_modifier()

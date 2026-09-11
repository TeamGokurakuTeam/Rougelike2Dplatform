extends Enemy
class_name Mushroom

@onready var wander_timer: Timer = $WanderTimer

@export var dash_speed : float = 1000

func Dash() -> void:
	var player : Player = get_tree().get_nodes_in_group("Player")[0]
	navigation_agent.target_position = player.global_position
	if navigation_agent.is_navigation_finished():
		return
	var next_pos : Vector2 =  navigation_agent.get_next_path_position()
	var player_dir_x : float = sign(next_pos.x - global_position.x)
	velocity.x += player_dir_x * dash_speed

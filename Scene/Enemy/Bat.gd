extends Enemy
class_name Bat

@export var attack_speed : float = 900.0

func Attack() -> void:
	var player : Player = get_tree().get_nodes_in_group("Player")[0]
	velocity = Vector2.ZERO
	await get_tree().create_timer(0.2).timeout
	navigation_agent.target_position = player.global_position
	if navigation_agent.is_navigation_finished():
		return
	var next_pos : Vector2 = navigation_agent.get_next_path_position()
	var dir := (next_pos - global_position).normalized()
	velocity = dir * attack_speed

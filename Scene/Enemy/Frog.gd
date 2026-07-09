extends Enemy
class_name Frog

var last_jump_dir_x = 1

func Jump() -> void:
	var player = get_tree().get_first_node_in_group("Player")
	if player == null:
		return
	navigation_agent.target_position = player.global_position
	if navigation_agent.is_navigation_finished():
		return
	var next_pos = navigation_agent.get_next_path_position()
	var dir = (next_pos - global_position).normalized()
	last_jump_dir_x = dir.x
	var jump_up = -350.0
	var jump_speed = 300.0
	velocity.x = dir.x * jump_speed
	velocity.y = jump_up

func Attack() -> void:
	if last_jump_dir_x > 0:
		scale.x = -abs(scale.x)
	else:
		scale.x = abs(scale.x)

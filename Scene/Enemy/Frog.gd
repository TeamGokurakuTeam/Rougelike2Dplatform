extends Enemy
class_name Frog

@export var Jump_up: float = -350.0
@export var Jump_speed: float = 300.0
@export var frog: Frog

var last_jump_dir_x: float = 0.0
var last_timer_dir_x: float = 0.0


func get_player() -> Node2D:
	return get_tree().get_first_node_in_group("Player") as Node2D

func is_player_right(player: Node2D) -> bool:
	if player == null:
		return true
	return player.global_position.x >= global_position.x

func is_player_left(player: Node2D) -> bool:
	if player == null:
		return true
	return player.global_position.x >= global_position.x * -1

func face_player(player: Node2D) -> void:
	if player == null:
		return
	if is_player_right(player):
		scale.x = -abs(scale.x)
	else:
		scale.x = abs(scale.x)

func Jump() -> void:
	var player := get_player()
	if player == null:
		return
	face_player(player)
	navigation_agent.target_position = player.global_position
	if navigation_agent.is_navigation_finished():
		return
	var dir = (player.global_position - global_position).normalized()
	last_jump_dir_x = dir.x
	velocity.x = dir.x * Jump_speed
	velocity.y = Jump_up

func Attack() -> void:
	var player := get_player()
	if player == null:
		return
	face_player(player)
	navigation_agent.target_position = player.global_position
	if navigation_agent.is_navigation_finished():
		return
	var dir = (player.global_position - global_position).normalized()
	last_timer_dir_x = dir.x
	velocity.x = dir.x * Jump_speed

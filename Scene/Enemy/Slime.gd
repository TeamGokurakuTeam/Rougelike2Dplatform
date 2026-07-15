extends Enemy
class_name Slime

const SPEED := 50.0
const JUMP_VELOCITY := -400.0

func get_player() -> Node2D:
	return get_tree().get_first_node_in_group("Player") as Node2D

func is_player_right(player: Node2D) -> bool:
	if player == null:
		return true
	return player.global_position.x >= global_position.x

func face_player(player: Node2D) -> void:
	if player == null:
		return
	if is_player_right(player):
		scale.x = -abs(scale.x)
	else:
		scale.x = abs(scale.x)

func Attack() -> void:
	var player := get_player()
	if player == null:
		return
	face_player(player)

extends State
class_name DarkSamuraiChase

@export var animation_player : AnimationPlayer
@export var parent : DarkSamurai

var player : Player

func Enter() -> void:
	animation_player.play("Move")
	if get_tree().get_node_count_in_group("Player"):
		player = get_tree().get_nodes_in_group("Player")[0]
	print(player)

func Exit() -> void:
	pass

func Update(delta) -> void:
	pass

func Physics_Update(delta) -> void:
	set_target(player.global_position)
	move_toward_player()
	parent.move_and_slide()

func set_target(target_pos : Vector2) -> void:
	parent.navigation_agent.target_position = target_pos

func move_toward_player() -> void:
	if parent.navigation_agent.is_navigation_finished():
		return
	
	var next_pos : Vector2 = parent.navigation_agent.get_next_path_position()
	var dir : Vector2 = (next_pos - parent.global_position).normalized()
	
	parent.velocity.x = dir.x * parent.max_speed
	
	print(str(dir.y) + "   " + str(parent.is_on_floor()))
	
	if dir.y < -0.9 and parent.is_on_floor():
		parent.velocity.y = parent.jump_velocity

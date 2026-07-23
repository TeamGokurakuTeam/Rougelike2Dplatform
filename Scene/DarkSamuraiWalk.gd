extends State
class_name DarkSamuraiChase

@export var chase_timer : Timer
@export var animation_player : AnimationPlayer
@export var parent : DarkSamurai

var player : Player

func Enter() -> void:
	animation_player.play("Walk")
	if get_tree().get_node_count_in_group("Player"):
		player = get_tree().get_nodes_in_group("Player")[0]
	chase_timer.start()

func Exit() -> void:
	chase_timer.stop()

func Update(delta) -> void:
	pass

func Physics_Update(delta) -> void:
	if player == null:
		return
	parent.move_and_slide()

func set_target(target_pos : Vector2) -> void:
	parent.navigation_agent.target_position = target_pos

func move_toward_player() -> void:
	if parent.navigation_agent.is_navigation_finished():
		return
	
	var next_pos : Vector2 = parent.navigation_agent.get_next_path_position()
	var dir : Vector2 = (next_pos - parent.global_position).normalized()
	
	parent.velocity.x = dir.x * parent.max_speed
	
	if dir.y < -0.9 and parent.is_on_floor():
		parent.velocity.y = parent.jump_velocity

func _on_player_detector_body_entered(body: Node2D) -> void:
	if body is Player:
		StateTransitioned.emit(self, "Attack")

func _on_chase_timer_timeout() -> void:
	if player != null:
		set_target(player.global_position)
		move_toward_player()

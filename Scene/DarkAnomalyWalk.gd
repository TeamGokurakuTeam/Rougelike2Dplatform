extends State
class_name DarkAnomalyWalk

@export var animation_player: AnimationPlayer
@export var parent: DarkDarkAnomaly

var player : Player

func Enter() -> void:
	animation_player.play("Walk")
	if get_tree().get_node_count_in_group("Player") > 0:
		player = get_tree().get_nodes_in_group("Player")[0]

func Exit() -> void:
	parent.velocity = Vector2.ZERO

func Update(delta) -> void:
	if not player:
		return
	var dist := parent.global_position.distance_to(player.global_position)
	if dist < 60.0:
		if randf( ) < 0.3:
			StateTransitioned.emit(self, "AttackSpecial")
		else:
			StateTransitioned.emit(self, "Attack")

func Physics_Update(delta) -> void:
	if not player:
		return
	parent.navigation_agent.target_position = player.global_position
	if parent.navigation_agent.is_navigation_finished():
		parent.velocity = Vector2.ZERO
		parent.move_and_slide()
		return
	var next_pos: Vector2 = parent.navigation_agent.get_next_path_position()
	var dir: Vector2 = (next_pos - parent.global_position).normalized()
	parent.velocity.x = dir.x * parent.max_speed
	if dir.y < -0.9 and parent.is_on_floor():
		parent.velocity.y = parent.jump_velocity
	if dir.x > 0:
		parent.animated_sprite.flip_h = false
	else:
		parent.animated_sprite.flip_h = true
	parent.move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		if randf() < 0.3:
			StateTransitioned.emit(self, "AttackSpecial")
		else:
			StateTransitioned.emit(self, "Attack")

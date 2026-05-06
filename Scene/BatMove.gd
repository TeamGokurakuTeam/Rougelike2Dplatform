extends State
class_name BatMove

@export var animation_player: AnimationPlayer
@export var parent: Bat

var player: Player

func Enter() -> void:
	animation_player.play("Move")
	if get_tree().get_node_count_in_group("Player") > 0:
		player = get_tree().get_nodes_in_group("Player")[0]

func Exit() -> void:
	parent.velocity = Vector2.ZERO

func Update(delta: float) -> void:
	if not parent.bite_timer.is_stopped():
		return

func Physics_Update(delta: float) -> void:
	set_target(player.global_position)
	move_toward_player(delta)
	parent.move_and_slide()

func set_target(target_pos: Vector2) -> void:
	parent.navigation_agent.target_position = target_pos

func move_toward_player(delta :float) -> void:
	if parent.navigation_agent.is_navigation_finished():
		return
	var next_pos: Vector2 = parent.navigation_agent.get_next_path_position()
	var dir: Vector2 = (next_pos - parent.global_position).normalized()
	var inertia := 0.25
	parent.velocity = parent.velocity.lerp(dir * parent.SPEED, inertia)
	if parent.velocity.length() > parent.SPEED:
		parent.velocity = parent.velocity.normalized() * parent.SPEED

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		var r = randf()
		if r < 0.5:
			StateTransitioned.emit(self, "Attack")
		else:
			StateTransitioned.emit(self, "Bite")

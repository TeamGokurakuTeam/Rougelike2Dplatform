extends State
class_name BatMove

@export var animation_player: AnimationPlayer
@export var parent : Bat

var player : Player
var has_bited := false  

func Enter() -> void:
	animation_player.play("Move")
	has_bited = false
	if get_tree().get_node_count_in_group("Player"):
		player = get_tree().get_nodes_in_group("Player")[0]

func Exit() -> void:
	pass

func Update(delta) -> void:
	pass

func Physics_Update(delta) -> void:
	var dist = parent.global_position.distance_to(player.global_position)


	if dist > 30 and not has_bited:
		has_bited = true
		animation_player.play("Bite")
		return  

	if has_bited and animation_player.current_animation == "Bite" and not animation_player.is_playing():
		StateTransitioned.emit(self, "Move")  
		return

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

	parent.velocity.x = dir.x * parent.SPEED
	parent.velocity.y = dir.y * parent.SPEED

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		StateTransitioned.emit(self , "Attack")  

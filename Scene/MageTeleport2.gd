extends State
class_name MegeTeleport2

@export var animation_player: AnimationPlayer
@export var parent : Mage

var player : Player
const TELEPORT_DISTANCE := 200.0

func Enter() -> void:
	animation_player.play("Teleport2")

	if get_tree().get_node_count_in_group("Player"):
		player = get_tree().get_nodes_in_group("Player")[0]

	if parent.position_history.size() > 0:
		var old_pos: Vector2 = parent.position_history[0]
		parent.global_position = old_pos

	parent.position_history.clear()
	parent.history_timer = 0.0

func Exit() -> void:
	pass

func Update(delta) -> void:
	if not animation_player.is_playing():
		StateTransitioned.emit(self , "Idle")

func Physics_Update(delta) -> void:
	pass

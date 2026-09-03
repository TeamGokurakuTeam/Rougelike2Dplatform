extends State
class_name TopHatSmash

@export var parent : TopHat
@export var animation_player : AnimationPlayer

func Enter() -> void:
	var player : Player = get_tree().get_first_node_in_group("Player")
	parent.jump_slam_attack(player)

func Exit() -> void:
	pass

func Update(delta) -> void:
	pass

func Physics_Update(delta) -> void:
	if parent.is_jump_attack:
		return
	super(delta)
	if parent.is_slamming and parent.is_on_floor():
		parent.is_slamming = false
		parent.on_slam_landed()

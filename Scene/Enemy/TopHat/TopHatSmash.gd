extends State
class_name TopHatSmash

@export var parent : TopHat
@export var animation_player : AnimationPlayer

var min_angle : float = -25
var max_angle : float = 25

func Enter() -> void:
	var player : Player = get_tree().get_first_node_in_group("Player")
	animation_player.play("Smash")
	parent.jump_slam_attack(player)
	await animation_player.animation_finished
	StateTransitioned.emit(self, "Idle")

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
		for i in parent.bullet_num:
			var angle : float = randf_range(min_angle, max_angle)
			parent._spawn_bullet(parent.global_position, angle)
	else:
		parent.move_and_slide()

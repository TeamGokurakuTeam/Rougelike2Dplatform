extends State
class_name GolemBossAttack

@export var parent : GolemBoss
@export var anim_player : AnimationPlayer

func Enter() -> void:
	anim_player.play("Attack")

func Exit() -> void:
	parent.can_move = true

func Update(delta) -> void:
	if not anim_player.is_playing():
		StateTransitioned.emit(self, "Fly")
	if parent.can_move:
		parent.set_target(parent.player.global_position)
		parent.move_toward_player()

func Physics_Update(delta) -> void:
	pass

extends State
class_name GolemBossAttack

@export var parent : GolemBoss
@export var anim_player : AnimationPlayer

var attack_count : int = 0

func Enter() -> void:
	attack_count = 1
	anim_player.play("Attack")

func Exit() -> void:
	attack_count = 1
	parent.can_move = true

func Update(delta) -> void:
	if not anim_player.is_playing() and attack_count < 3:
		attack_count += 1
		anim_player.play("Attack")
	elif not anim_player.is_playing() and attack_count >= 3:
		StateTransitioned.emit(self, "Fly")
		
	if parent.can_move:
		parent.set_target(parent.player.global_position)
		parent.move_toward_player()

func Physics_Update(delta) -> void:
	pass

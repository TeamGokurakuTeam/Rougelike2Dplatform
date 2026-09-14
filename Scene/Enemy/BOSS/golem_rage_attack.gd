extends State
class_name GolemBossRageAttack

@export var parent : GolemBoss
@export var anim_player : AnimationPlayer

func Enter() -> void:
	anim_player.play("RageAttack")
	await anim_player.animation_finished
	StateTransitioned.emit(self, "Attack")

func Exit() -> void:
	pass

func Update(delta) -> void:
	pass

func Physics_Update(delta) -> void:
	pass

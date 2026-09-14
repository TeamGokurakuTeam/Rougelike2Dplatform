extends State
class_name GolemBossRage

@export var parent : GolemBoss
@export var anim_player : AnimationPlayer

func Enter() -> void:
	anim_player.play("Rage")
	await anim_player.animation_finished
	parent.is_rage = true
	StateTransitioned.emit(self, "Move")

func Exit() -> void:
	pass

func Update(delta) -> void:
	pass

func Physics_Update(delta) -> void:
	pass

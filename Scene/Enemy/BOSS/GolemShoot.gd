extends State
class_name GolemBossShoot

@export var parent : GolemBoss
@export var anim_player : AnimationPlayer

var dir_player : Vector2

func Enter() -> void:
	if parent.is_rage:
		for i in 2:
			anim_player.play("ShootingArm")
			await anim_player.animation_finished
	else:
		anim_player.play("ShootingArm")
		await anim_player.animation_finished
	if not parent.is_rage and parent.hp_component.hp <= parent.hp_component.max_hp / 3:
		StateTransitioned.emit(self, "Rage")
		return
	StateTransitioned.emit(self, "Attack")

func Exit() -> void:
	pass

func Update(delta) -> void:
	if parent.player == null:
		return
	dir_player = (parent.player.global_position - parent.global_position).normalized()
	if dir_player.x < 0:
		parent.sprite.flip_h = true
	else:
		parent.sprite.flip_h = false
	
	if parent.sprite.flip_h:
		parent.root_node.scale.x = -1
	else:
		parent.root_node.scale.x = 1
	

func Physics_Update(delta) -> void:
	pass

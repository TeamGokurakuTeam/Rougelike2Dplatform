extends State
class_name GolemBossShoot

@export var parent : GolemBoss
@export var anim_player : AnimationPlayer

var dir_player : Vector2

func Enter() -> void:
	anim_player.play("ShootingArm")

func Exit() -> void:
	pass

func Update(delta) -> void:
	if parent.player != null:
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
	if not anim_player.is_playing():
		StateTransitioned.emit(self, "Move")

func Physics_Update(delta) -> void:
	pass

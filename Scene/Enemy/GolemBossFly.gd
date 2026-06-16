extends State
class_name GolemBossFly

@export var parent : GolemBoss
@export var anim_player : AnimationPlayer
@export var fly_timer : Timer

func Enter() -> void:
	parent.can_move = false
	anim_player.play("FlyStart")
	await anim_player.animation_finished
	fly_timer.start()
	anim_player.play("Flying")
	parent.can_move = true

func Exit() -> void:
	pass

func Update(delta) -> void:
	pass

func Physics_Update(delta) -> void:
	parent.GolemFlyRotate(delta)
	
	#----------------test用----------------#
	if parent.player == null:
		return
	if parent.can_move:
		parent.set_target(parent.player.global_position)
		parent.move_toward_player()
		parent.move_and_slide()
	#--------------------------------------#

#----------------test用----------------#


func _on_fly_timer_timeout() -> void:
	parent.can_move = false
	parent.animation_player.play("FlyEnd")
	await anim_player.animation_finished
	parent.can_move = true
	StateTransitioned.emit(self, "Move")

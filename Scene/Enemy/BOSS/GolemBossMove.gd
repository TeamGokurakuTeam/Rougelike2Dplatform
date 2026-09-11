extends State
class_name GolemBossMove

@export var parent : GolemBoss
@export var anim_player : AnimationPlayer
@export var move_timer : Timer

func Enter() -> void:
	move_timer.start()
	anim_player.play("Move")

func Exit() -> void:
	pass

func Update(delta) -> void:
	pass

func Physics_Update(delta) -> void:
	pass

func _on_move_timer_timeout() -> void:
	StateTransitioned.emit(self, "Shoot")

extends State
class_name BatIdle

@export var parent : BatMan
@export var anim_player : AnimationPlayer

@export var idle_timer : Timer

func Enter() -> void:
	anim_player.play("BatAnim/IdleWander")

func Exit() -> void:
	pass

func Update(delta) -> void:
	pass
		

func Physics_Update(delta) -> void:
	parent.sprite.flip_h = parent.velocity.x < 0
	if parent.hp_component.hp <= 0:
		StateTransitioned.emit(self, "Dead")
	if parent.is_player_entered:
		StateTransitioned.emit(self, "Chase")
	if parent.is_damaged:
		StateTransitioned.emit(self, "hurt")

func _on_idle_timer_timeout() -> void:
	if randf() <= 0.5:
		StateTransitioned.emit(self, "Wander")
	else:
		idle_timer.start()

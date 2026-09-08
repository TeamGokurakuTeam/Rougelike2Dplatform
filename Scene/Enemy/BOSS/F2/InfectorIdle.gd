extends State
class_name InfectorIdle

@export var parent : Infector
@export var anim_player : AnimationPlayer
@export var timer : Timer

func Enter() -> void:
	anim_player.play("Idle")
	timer.start()

func Exit() -> void:
	pass

func Update(delta) -> void:
	pass

func Physics_Update(delta) -> void:
	pass

func _on_idle_timer_timeout() -> void:
	StateTransitioned.emit(self, "Slam")

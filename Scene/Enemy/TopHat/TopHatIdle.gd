extends State
class_name TopHatIdle

@export var parent : TopHat
@export var animation_player : AnimationPlayer
@export var idle_timer : Timer

func Enter() -> void:
	idle_timer.wait_time = randf_range(1.0, 3.0)
	idle_timer.start()
	animation_player.play("Idle")

func Exit() -> void:
	pass

func Update(delta) -> void:
	pass

func Physics_Update(delta) -> void:
	pass

func _on_timer_timeout() -> void:
	StateTransitioned.emit(self, "Smash")

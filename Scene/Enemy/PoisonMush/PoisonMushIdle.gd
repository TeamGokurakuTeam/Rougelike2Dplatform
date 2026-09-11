extends State
class_name PoisonMushIdle

@export var parent : PoisonMush
@export var anim_player : AnimationPlayer
@export var idle_timer : Timer

func Enter() -> void:
	idle_timer.wait_time = randf_range(1.5, 3.5)
	idle_timer.start()
	anim_player.play("Idle")

func Exit() -> void:
	pass

func Update(delta) -> void:
	pass

func Physics_Update(delta) -> void:
	pass

func _on_idle_timer_timeout() -> void:
	StateTransitioned.emit(self, "Wander")


func _on_player_detector_body_entered(body: Node2D) -> void:
	if body is Player:
		StateTransitioned.emit(self, "Jump")

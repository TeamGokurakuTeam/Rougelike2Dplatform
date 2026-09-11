extends State
class_name HedoroSlimeIdle

@export var parent : HedoroSlime
@export var anim_player : AnimationPlayer
@export var idle_timer : Timer

func Enter() -> void:
	idle_timer.wait_time = randf_range(1.3, 3.9)
	anim_player.play("Idle")
	idle_timer.start()

func Exit() -> void:
	pass

func Update(delta) -> void:
	pass

func Physics_Update(delta) -> void:
	pass

func _on_idle_timer_timeout() -> void:
	StateTransitioned.emit(self, "Walk")

func _on_player_detector_body_entered(body: Node2D) -> void:
	StateTransitioned.emit(self, "Attack")

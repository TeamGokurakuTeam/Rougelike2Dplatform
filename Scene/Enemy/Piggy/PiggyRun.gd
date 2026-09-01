extends State
class_name PiggyRun

@export var parent : Piggy
@export var animation_player: AnimationPlayer

func Enter() -> void:
	animation_player.play("Run")
	parent.player_detector.monitoring = false
	parent.player_detector.set_deferred("monitorable", false)
	parent.flee_from_player()

func Exit() -> void:
	pass

func Physics_Update(delta: float) -> void:
	parent.flee_from_player()

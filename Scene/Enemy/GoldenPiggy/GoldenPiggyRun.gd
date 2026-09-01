extends State
class_name GoldenPiggyRun

@export var parent : GoldenPiggy
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

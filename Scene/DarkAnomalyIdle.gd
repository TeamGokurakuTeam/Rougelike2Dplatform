extends State
class_name DarkAnomaly

@export var animation_player: AnimationPlayer
@export var parent : DarkAnomaly

func Enter() -> void:
	animation_player.play("Idle")

func Exit() -> void:
	pass

func Update(delta) -> void:
	if not animation_player.is_playing():
		StateTransitioned.emit(self, "Walk")

func Physics_Update(delta) -> void:
	pass

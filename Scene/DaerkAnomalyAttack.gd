extends State
class_name DakAnomalyAttack

@export var animation_player : AnimationPlayer
@export var parent : DarkDarkAnomaly

func Enter() -> void:
	animation_player.play("Attack")

func Exit() -> void:
	pass

func Update(delta) -> void:
	if not animation_player.is_playing():
		StateTransitioned.emit(self,"Idle")

func Physics_Update(delta) -> void:
	pass

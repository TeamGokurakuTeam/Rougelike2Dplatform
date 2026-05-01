extends State
class_name KnightShieldBash

@export var animation_player: AnimationPlayer
@export var parent : KnightShieldBash



func Enter() -> void:
	animation_player.play("ShieldBash")

func Exit() -> void:
	pass



func Update(delta) -> void:
	if not animation_player.is_playing():
		StateTransitioned.emit(self, "ShieldBash")

func Physics_Update(delta) -> void:
	pass

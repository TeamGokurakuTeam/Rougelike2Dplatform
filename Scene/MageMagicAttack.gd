extends State
class_name MageMagicAttak

@export var animation_player: AnimationPlayer
@export var parent : MageMagicAttak

func Enter() -> void:
	animation_player.play("MagicAttack")

func Exit() -> void:
	pass

func Update(delta) -> void:
	if not animation_player.is_playing():
		StateTransitioned.emit(self , "Idle")

func Physics_Update(delta) -> void:
	pass

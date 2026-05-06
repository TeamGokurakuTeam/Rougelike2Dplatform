extends State
class_name KnightNearAttack

@export var animation_player: AnimationPlayer
@export var parent : KnightNearAttack

func Enter() -> void:
	animation_player.play("NearAttack")

func Exit() -> void:
	pass

func Update(delta) -> void:
	if not animation_player.is_playing():
		StateTransitioned.emit(self ,"Idle")

func Physics_Update(delta) -> void:
	pass

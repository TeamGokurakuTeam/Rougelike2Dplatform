extends State
class_name MageTeleport

@export var animation_player: AnimationPlayer
@export var parent : MageTeleport



func Enter() -> void:
	animation_player.play("Teleport")

func Exit() -> void:
	pass

func Update(delta) -> void:
	if not animation_player.is_playing():
		StateTransitioned.emit(self , "Teleport2")

func Physics_Update(delta) -> void:
	pass

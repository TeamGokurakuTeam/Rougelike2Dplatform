extends State
class_name MageTeleport

@export var animation_player: AnimationPlayer
@export var parent : Mage

func Enter() -> void:
	animation_player.play("Teleport")
	if parent.position_history.size() > 0:
		parent.teleport_prev_data = {"old_pos" : parent.position_history[0]}

func Exit() -> void:
	pass

func Update(delta) -> void:
	if not animation_player.is_playing():
		StateTransitioned.emit(self , "Teleport2")

func Physics_Update(delta) -> void:
	pass

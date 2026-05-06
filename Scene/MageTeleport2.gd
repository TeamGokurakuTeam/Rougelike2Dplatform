extends State
class_name MegeTeleport2

@export var animation_player: AnimationPlayer
@export var parent : Mage

var player : Player

func Enter() -> void:
	animation_player.play("Teleport2")
	var old_pos = parent.teleport_prev_data.get("old_pos" , null)
	if old_pos != null:
		parent.global_position = old_pos
	parent.position_history.clear()

func Exit() -> void:
	pass

func Update(delta) -> void:
	if not animation_player.is_playing():
		StateTransitioned.emit(self , "Idle")

func Physics_Update(delta) -> void:
	pass

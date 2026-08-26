extends State
class_name DarkSamuraiIdle

@export var animation_player : AnimationPlayer
@export var parent : DarkSamurai

func Enter() -> void:
	animation_player.play("Idle")

func Exit() -> void:
	pass

func Update(delta) -> void:
	if not animation_player.is_playing():
		StateTransitioned.emit(self, "Chase")

func Physics_Update(delta) -> void:
	pass

func _on_hp_component_hp_changed() -> void:
	StateTransitioned.emit(self , "Hurt")

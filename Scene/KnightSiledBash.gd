extends State
class_name KnightShieldBash

@export var animation_player: AnimationPlayer
@export var parent : Knight 

func Enter() -> void:
	parent.is_shielding = true 
	animation_player.play("ShieldBash")

func Exit() -> void:
	parent.is_shielding = false  

func Update(delta) -> void:
	if not animation_player.is_playing():
		StateTransitioned.emit(self, "Idle")

func Physics_Update(delta) -> void:
	pass

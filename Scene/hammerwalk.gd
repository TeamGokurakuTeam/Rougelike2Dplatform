extends State
class_name HammerWalk

@export var parent : HammerBro
@export var anim_player : AnimationPlayer

func Enter() -> void:
	parent.friction = 0.05
	anim_player.play("Dash")

func Exit() -> void:
	parent.friction = 0.15

func Update(delta) -> void:
	if not anim_player.is_playing():
		StateTransitioned.emit(self, "Idle")

func Physics_Update(delta) -> void:
	pass

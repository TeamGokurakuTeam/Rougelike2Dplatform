extends State
class_name KnightHit

@export var animation_player: AnimationPlayer
@export var parent: Knight

func Enter() -> void:
	parent.velocity = Vector2.ZERO
	animation_player.play("Hit")

func Exit() -> void:
	pass

func Update(delta: float) -> void:
	if not animation_player.is_playing():
		StateTransitioned.emit(self, "Idle")

func Physics_Update(delta: float) -> void:
	parent.velocity = Vector2.ZERO

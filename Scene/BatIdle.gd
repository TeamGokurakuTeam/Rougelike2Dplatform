extends State
class_name BatIdle

@export var animation_player: AnimationPlayer
@export var parent: Bat

func Enter() -> void:
	animation_player.play("Idle")
	parent.cool_down.start()

func Update(delta: float) -> void:
	if parent.cool_down.is_stopped():
		StateTransitioned.emit(self, "Move")

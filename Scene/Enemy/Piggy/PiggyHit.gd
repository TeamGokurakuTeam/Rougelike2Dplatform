extends State
class_name PiggyHit

@export var parent: Piggy
@export var animation_player: AnimationPlayer

func Enter() -> void:
	animation_player.play("Hit")

func Update(delta) -> void:
	if not animation_player.is_playing():
		StateTransitioned.emit(self, "Run")

func Exit() -> void:
	parent.is_in_hit = false

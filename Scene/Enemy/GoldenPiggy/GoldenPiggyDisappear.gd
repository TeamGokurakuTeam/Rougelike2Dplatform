extends State
class_name GoldenPiggyDisappear

@export var parent: GoldenPiggy
@export var animation_player: AnimationPlayer

func Enter() -> void:
	animation_player.play("Disappear")
	

func Exit() -> void:
	pass

func Update(delta) -> void:
	if not animation_player.is_playing():
		StateTransitioned.emit(self, "Run")

func Physics_Update(delta) -> void:
	pass

extends State
class_name GoldenPiggyDiscovery

@export var parent: GoldenPiggy
@export var animation_player: AnimationPlayer

func Enter() -> void:
	animation_player.play("Discovery")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Discovery":
		StateTransitioned.emit(self, "Run")

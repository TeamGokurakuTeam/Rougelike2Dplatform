extends State
class_name GoldenPiggyDisappear

@export var parent: GoldenPiggy
@export var animation_player: AnimationPlayer

func Enter() -> void:
	animation_player.play("Disappear")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Disappear":
		parent.queue_free()

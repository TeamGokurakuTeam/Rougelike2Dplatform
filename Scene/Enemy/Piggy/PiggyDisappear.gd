extends State
class_name PiggyDisappear

@export var parent: Piggy
@export var animation_player: AnimationPlayer

func Enter() -> void:
	animation_player.play("Disappear")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Disappear":
		parent.queue_free()

extends State
class_name DarkSamuraiHurt

@export var parent : DarkSamurai
@export var animation_player: AnimationPlayer

func Enter() -> void:
	animation_player.play("Hurt")

func Exit() -> void:
	pass

func Update(delta) -> void:
	if not animation_player.is_playing():
		StateTransitioned.emit(self,"Idle")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	StateTransitioned.emit(self , "Idle")

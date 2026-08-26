extends State
class_name MushHurt

@export var parent : Mushroom
@export var anim_player : AnimationPlayer


func Enter() -> void:
	anim_player.play("Hurt")

func Exit() -> void:
	pass

func Update(delta) -> void:
	if not anim_player.is_playing():
		StateTransitioned.emit(self , "Idle")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	StateTransitioned.emit(self , "Idle")

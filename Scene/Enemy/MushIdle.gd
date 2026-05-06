extends State
class_name MushIdle

@export var parent : Mushroom
@export var anim_player : AnimationPlayer

func Enter() -> void:
	anim_player.play("Idle")

func Exit() -> void:
	pass

func Update(delta) -> void:
	if not anim_player.is_playing():
		if randf() <= 0.4:
			StateTransitioned.emit(self, "Wander")
		else:
			StateTransitioned.emit(self, "Idle")
			#わからんので試してみる(Idle to Idle)

func Physics_Update(delta) -> void:
	pass


func _on_player_detector_body_entered(body: Node2D) -> void:
	if body is Player:
		StateTransitioned.emit(self, "Dash")

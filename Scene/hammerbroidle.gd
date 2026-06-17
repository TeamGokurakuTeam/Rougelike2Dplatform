extends State
class_name HammerIdle

@export var parent : HammerBro
@export var anim_player : AnimationPlayer

func Enter() -> void:
	anim_player.play("Idle")

func Exit() -> void:
	pass

func Update(delta) -> void:
	if not anim_player.is_playing():
		if randf() <= 0.4:
			StateTransitioned.emit(self, "Walk")
		else:
			StateTransitioned.emit(self, "Idle")
			#わからんので試してみる(Idle to Idle)

func Physics_Update(delta) -> void:
	pass


func _on_player_detector_body_entered(body: Node2D) -> void:
	if body is Player:
		StateTransitioned.emit(self, "Atack")

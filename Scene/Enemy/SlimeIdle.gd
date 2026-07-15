extends State
class_name SlimeIdle

@export var parent : Slime
@export var anim_player : AnimationPlayer

func Enter() -> void:
	anim_player.play("Idle")

func Exit() -> void:
	pass

func Update(delta) -> void:
	if not anim_player.is_playing():
		StateTransitioned.emit(self, "Idle")

func _on_player_detector_body_entered(body: Node2D) -> void:
	if body is Player:
		StateTransitioned.emit(self, "Walk")

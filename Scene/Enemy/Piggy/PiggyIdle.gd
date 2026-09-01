extends State
class_name PiggyIdle

@export var parent: Piggy
@export var animation_player: AnimationPlayer

func Enter() -> void:
	animation_player.play("Idle")

func _on_player_detector_body_entered(body: Node2D) -> void:
	if body is Player:
		StateTransitioned.emit(self, "Discovery")

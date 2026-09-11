extends State
class_name FrogIdle

@export var parent : Frog
@export var animation_player: AnimationPlayer

func Enter() -> void:
	animation_player.play("Idle")

func _process(delta: float) -> void:
	pass

func Exit() -> void:
	pass

func Update(delta) -> void:
	if not animation_player.is_playing():
		StateTransitioned.emit(self, "Idle")

func Physics_Update(delta) -> void:
	pass

func _on_player_detector_body_entered(body: Node2D) -> void:
	if body is Player:
		StateTransitioned.emit(self, "Jump")

extends State
class_name BatIdle


@export var parent : Bat
@export var animation_player: AnimationPlayer

func Enter() -> void:
	animation_player.play("Idle")

func Exit() -> void:
	pass

func Update(delta) -> void:
	if not animation_player.is_playing():
		StateTransitioned.emit(self, "Idle")


func _on_player_detector_body_entered(body: Node2D) -> void:
	if body is Player:
		StateTransitioned.emit(self, "Attack")

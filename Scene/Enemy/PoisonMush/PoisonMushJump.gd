extends State
class_name PoisonMushJump
@onready var attack: AudioStreamPlayer = $"../../Attack"

@export var parent : PoisonMush
@export var anim_player : AnimationPlayer

func Enter() -> void:
	anim_player.play("Jump")
	attack.play()
func Exit() -> void:
	pass

func Update(delta) -> void:
	pass

func Physics_Update(delta) -> void:
	if not anim_player.is_playing():
		StateTransitioned.emit(self, "Wander")

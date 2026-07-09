extends State
class_name FrogJump

@export var parent : Frog
@export var animation_player: AnimationPlayer
@onready var player: Player

func Enter() -> void:
	animation_player.play("Jump")
	parent.Jump()
	await animation_player.animation_finished
	parent.velocity = Vector2.ZERO
	StateTransitioned.emit(self, "Attack")

func Exit() -> void:
	pass

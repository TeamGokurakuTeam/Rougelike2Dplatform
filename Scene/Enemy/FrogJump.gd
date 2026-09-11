extends State
class_name FrogJump

@export var parent: Frog
@export var animation_player: AnimationPlayer
@export var animated_sprite_2d: AnimatedSprite2D

func Enter() -> void:
	var player := parent.get_player()
	if player == null:
		return
	parent.face_player(player)
	if parent.is_player_right(player):
		animated_sprite_2d.flip_h = false
		animation_player.play("Jump")
	else:
		animated_sprite_2d.flip_h = true
		animation_player.play("Jump")
	parent.Jump()
	await animation_player.animation_finished
	StateTransitioned.emit(self, "Attack")

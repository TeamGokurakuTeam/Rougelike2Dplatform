extends State
class_name KnightShield

@export var animation_player: AnimationPlayer
@export var parent: Knight
@export var hurtbox: Hurtbox
@export var shield_hitbox: Area2D

func Enter() -> void:
	animation_player.play("Shield")

	if hurtbox:
		hurtbox.monitoring = false

	if shield_hitbox:
		shield_hitbox.monitoring = true

func Exit() -> void:
	if hurtbox:
		hurtbox.monitoring = true

	if shield_hitbox:
		shield_hitbox.monitoring = false

func Update(delta) -> void:
	if not animation_player.is_playing():
		StateTransitioned.emit(self, "NearAttack")

func Physics_Update(delta) -> void:
	pass

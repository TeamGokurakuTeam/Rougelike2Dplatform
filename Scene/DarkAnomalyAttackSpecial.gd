extends State
class_name DarkAnomalyAttackSpecial

@export var animation_player: AnimationPlayer
@export var parent : DarkDarkAnomaly

var dash_speed : float = 300.0
var dir : int= 1

func Enter() -> void:
	animation_player.play("AttackSpecial")
	parent.navigation_agent.avoidance_enabled = false
	if parent.animated_sprite.flip_h:
		dir = -1
	else:
		dir = 1
	parent.velocity.x = dir * dash_speed

func Exit() -> void:
	parent.navigation_agent.avoidance_enabled = true
	parent.velocity = Vector2.ZERO

func Physics_Update(delta) -> void:
	parent.move_and_slide()

func Update(delta) -> void:
	if not animation_player.is_playing():
		StateTransitioned.emit(self, "Idle")

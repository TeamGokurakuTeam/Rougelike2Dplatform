extends State
class_name DarkAnomalyAttackSpecial

@export var animation_player: AnimationPlayer
@export var parent : DarkDarkAnomaly

var dash_speed := 300.0
var dir := 1

func Enter() -> void:
	animation_player.play("AttackSpecial")
	parent.navigation_agent.avoidance_enabled = false
	dir = sign(parent.velocity.x)
	if dir == 0:
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

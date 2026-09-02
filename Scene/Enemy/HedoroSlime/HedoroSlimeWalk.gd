extends State
class_name HedoroSlimeWalk

@export var parent : HedoroSlime
@export var anim_player : AnimationPlayer
@export var walk_timer : Timer

var direction : Vector2

func Enter() -> void:
	walk_timer.wait_time = randf_range(1.0, 3.0)
	walk_timer.start()
	anim_player.play("Walk")
	if randf() <= 0.5:
		direction = Vector2.RIGHT
	else:
		direction = Vector2.LEFT

func Exit() -> void:
	pass

func Update(delta) -> void:
	pass

func Physics_Update(delta) -> void:
	parent.velocity += direction * parent.acceleration

func _on_walk_timer_timeout() -> void:
	StateTransitioned.emit(self, "Idle")

func _on_player_detector_body_entered(body: Node2D) -> void:
	StateTransitioned.emit(self, "Attack")

extends State
class_name MushWander

@export var parent : Mushroom
@export var anim_player : AnimationPlayer

var direction : Vector2

func Enter() -> void:
	anim_player.play("Walk")
	parent.wander_timer.start()
	if randf() <= 0.5:
		direction = Vector2.RIGHT
	else:
		direction = Vector2.LEFT
	

func Exit() -> void:
	pass

func Update(delta) -> void:
	pass

func Physics_Update(delta) -> void:
	parent.velocity += direction * parent.speed

func _on_timer_timeout() -> void:
	StateTransitioned.emit(self, "Idle")

func _on_player_detector_body_entered(body: Node2D) -> void:
	if body is Player:
		StateTransitioned.emit(self, "Dash")

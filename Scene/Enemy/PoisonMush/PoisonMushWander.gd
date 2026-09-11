extends State
class_name PoisonMushWander

@export var parent : PoisonMush
@export var anim_player : AnimationPlayer
@export var wander_timer : Timer

var direction : Vector2

func Enter() -> void:
	anim_player.play("Move")
	wander_timer.start()
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

func _on_wander_timer_timeout() -> void:
	StateTransitioned.emit(self, "Chase")


func _on_player_detector_body_entered(body: Node2D) -> void:
	if body is Player:
		StateTransitioned.emit(self, "Jump")

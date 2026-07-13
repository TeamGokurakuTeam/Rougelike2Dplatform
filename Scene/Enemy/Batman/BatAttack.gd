extends State
class_name BatAttack

@export var parent : Bat
@export var anim_player : AnimationPlayer

func Enter() -> void:
	anim_player.play("BatAnim/Attack")

func Exit() -> void:
	pass

func Update(delta) -> void:
	pass

func Physics_Update(delta) -> void:
	if parent.is_damaged:
		StateTransitioned.emit(self, "hurt")
	if parent.hp_component.hp <= 0:
		StateTransitioned.emit(self, "Dead")
	parent.sprite.flip_h = parent.velocity.x < 0
	parent.move_and_slide()

func _rush_attack() -> void:
	var tween : Tween = get_parent().create_tween()
	parent.ghost_timer.start()
	if parent.target == null:
		return
	
	var rush_speed : float = parent.max_speed * 3
	var dir : Vector2 = parent.global_position.direction_to(parent.target.global_position)
	tween.tween_property(parent, "velocity", dir * rush_speed, 0.6).set_trans(tween.TRANS_ELASTIC).set_ease(tween.EASE_OUT)
	tween.tween_property(parent, "velocity", Vector2.ZERO, 0.1)
	await tween.finished
	parent.ghost_timer.stop()
	StateTransitioned.emit(self, "Idle")

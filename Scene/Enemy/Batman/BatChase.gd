extends EnemyState
class_name BatChase

func Enter() -> void:
	anim_player.play("Chase")

func Exit() -> void:
	pass

func Update(delta) -> void:
	pass

func Physics_Update(delta) -> void:
	if parent.hp_component.hp <= 0:
		StateTransitioned.emit(self, "Dead")
	if parent.is_damaged:
		StateTransitioned.emit(self, "hurt")
	parent.sprite.flip_h = parent.velocity.x < 0
	parent.move_direction = get_next_direction().normalized()
	parent.velocity = parent.move_direction * parent.speed / 2
	parent.move_and_slide()
	if not parent.is_player_entered:
		if randf() <= 0.5:
			StateTransitioned.emit(self, "Attack")
		else:
			StateTransitioned.emit(self, "Wander")

func get_next_direction() -> Vector2:
	if parent.navigation_agent.is_target_reached():
		return Vector2.ZERO
	else:
		var vector_to_next_point : Vector2 = parent.navigation_agent.get_next_path_position() - parent.global_position
		return vector_to_next_point.normalized()

func _on_hurtbox_recieved_damage(damage: int, knockback_dir: Vector2) -> void:
	StateTransitioned.emit(self, "Attack")

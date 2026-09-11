extends State
class_name SkullWolfIdle

@export var parent : SkullWolf
@export var animation_player : AnimationPlayer
@export var idle_timer : Timer

func Enter() -> void:
	idle_timer.wait_time = randf_range(2.0, 7.5)
	idle_timer.start()
	animation_player.play("Idle")

func Exit() -> void:
	parent.prev_state = "Idle"

func Update(delta) -> void:
	pass

func Physics_Update(delta) -> void:
	pass

func _on_idle_timer_timeout() -> void:
	StateTransitioned.emit(self, "Chase")

func _on_hurtbox_recieved_damage(damage: float, knockback_dir: Vector2) -> void:
	idle_timer.stop()
	StateTransitioned.emit(self, "Hurt")

func _on_hp_component_is_dead() -> void:
	StateTransitioned.emit(self, "Dead")

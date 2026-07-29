extends BounceProjectile
class_name DuckProjectile

@export var is_explosion: bool = false
@export var should_explode: bool = false
 
func _play_spawn_animation() -> void:
	if animation_player:
		animation_player.play("RollDuck")
 
func _should_process_physics() -> bool:
	return not is_explosion

func _despawn() -> void:
	if should_explode:
		await _explode()
	else:
		queue_free()

func _explode() -> void:
	if animation_player:
		animation_player.play("BombDuck")
		await animation_player.animation_finished
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	pass

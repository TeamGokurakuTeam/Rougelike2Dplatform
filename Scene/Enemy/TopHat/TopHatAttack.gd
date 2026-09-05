extends State
class_name TopHatAttack

@export var parent : TopHat
@export var animation_player : AnimationPlayer
@export var attack_timer : Timer

var player : Player

func Enter() -> void:
	parent.sprite.self_modulate = Color("ffffff")
	if get_tree().get_node_count_in_group("Player"):
		player = get_tree().get_first_node_in_group("Player")
	if player != null:
		attack_timer.start()
		animation_player.play("Attack")
		parent.set_target(player.global_position)
	await get_tree().create_timer(1.2).timeout
	StateTransitioned.emit(self, "Idle")

func Exit() -> void:
	parent.sprite.self_modulate = Color("ffffff")

func Update(delta) -> void:
	pass

func Physics_Update(delta) -> void:
	if player == null:
		return
	if not parent.is_on_floor() and not parent.is_fly:
		parent.velocity += parent.get_gravity() * delta
	parent.move_and_slide()

func _on_attack_timer_timeout() -> void:
	if player == null:
		return
	parent.move_toward_player()

extends State
class_name SkullWolfChase

@export var parent : SkullWolf
@export var animation_player : AnimationPlayer
@export var chase_timer : Timer
@export var target_cooldown : Timer

var player : Player
var tween : Tween

func Enter() -> void:
	parent.hitboxes_array[0].damage = 8
	chase_timer.wait_time = randf_range(3.0, 5.0)
	chase_timer.start()
	animation_player.play("Attack")
	target_cooldown.start()
	player = get_tree().get_first_node_in_group("Player")

func Exit() -> void:
	target_cooldown.stop()

func Update(delta) -> void:
	pass

func Physics_Update(delta) -> void:
	if player == null:
		return
	parent.move_toward_player()
	parent.move_and_slide()

func _on_target_cooldown_timeout() -> void:
	if player == null:
		return
	parent.set_target(player.global_position)
	if randf_range(0, 1.0) <= 0.1:
		StateTransitioned.emit(self, "Rage")


func _on_chase_timer_timeout() -> void:
	StateTransitioned.emit(self, "Idle")


func _on_hp_component_is_dead() -> void:
	pass # Replace with function body.

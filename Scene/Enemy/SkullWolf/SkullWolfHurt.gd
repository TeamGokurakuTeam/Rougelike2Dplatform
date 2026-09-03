extends State
class_name SkullWolfHurt

@export var parent : SkullWolf
@export var animation_player : AnimationPlayer

func Enter() -> void:
	animation_player.play("Hurt")
	await animation_player.animation_finished
	if parent.prev_state == "Idle":
		StateTransitioned.emit(self, "Chase")
	elif parent.prev_state == "Rage":
		StateTransitioned.emit(self, "Idle")
	else:
		StateTransitioned.emit(self, "Chase")

func Exit() -> void:
	pass

func Update(delta) -> void:
	pass

func Physics_Update(delta) -> void:
	pass


func _on_hp_component_is_dead() -> void:
	pass # Replace with function body.

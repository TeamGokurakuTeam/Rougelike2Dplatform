extends State
class_name MageSpell

@export var animation_player: AnimationPlayer
@export var parent: Node2D     
@export var flare_ball_scene: PackedScene  

func Enter() -> void:
	animation_player.play("Spell")
	_spawn_flare_ball()

func Exit() -> void:
	pass

func Update(delta) -> void:
	if not animation_player.is_playing():
		StateTransitioned.emit(self, "Idle")

func Physics_Update(delta) -> void:
	pass

func _spawn_flare_ball() -> void:
	if flare_ball_scene == null:
		return
	var flare = flare_ball_scene.instantiate()
	var spawn_pos = parent.global_position + Vector2(0, -40)
	flare.global_position = spawn_pos
	get_tree().current_scene.add_child(flare)

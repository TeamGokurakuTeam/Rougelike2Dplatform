extends State
class_name SlimeWalk

@export var parent : Slime
@export var anim_player : AnimationPlayer

func Enter() -> void:
	anim_player.play("Walk")
	if parent.hitboxes_array.size() > 0:
		parent.hitboxes_array[0].damage = 5

func Exit() -> void:
	pass

func Update(delta) -> void:
	var player := parent.get_player()
	parent.face_player(player)
	if not anim_player.is_playing():
		StateTransitioned.emit(self, "Idle")

func Physics_Update(delta) -> void:
	var player := parent.get_player()
	if player == null:
		return
	parent.navigation_agent.target_position = player.global_position
	if parent.navigation_agent.is_navigation_finished():
		return
	var next_pos := parent.navigation_agent.get_next_path_position()
	var dir_x = sign(next_pos.x - parent.global_position.x)
	parent.velocity.x = dir_x * Slime.SPEED
	await anim_player.animation_finished
	StateTransitioned.emit(self, "Attack")

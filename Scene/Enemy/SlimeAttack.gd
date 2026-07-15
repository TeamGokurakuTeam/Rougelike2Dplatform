extends State
class_name SlimeAttack

@export var parent : Slime
@export var anim_player : AnimationPlayer

func Enter() -> void:
	var player := parent.get_player()
	parent.face_player(player)
	anim_player.play("Attack")
	parent.Attack()
	if parent.hitboxes_array.size() > 0:
		parent.hitboxes_array[0].damage = 7

func Exit() -> void:
	pass

func Update(delta) -> void:
	if not anim_player.is_playing():
		StateTransitioned.emit(self, "Idle")

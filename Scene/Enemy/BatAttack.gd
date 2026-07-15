extends State
class_name BatAttack

@export var parent : Bat
@export var animation_player: AnimationPlayer

func Enter() -> void:
	animation_player.play("Attack")
	parent.Attack()
	if parent.hitboxes_array.size() > 0:
		parent.hitboxes_array[0].damage = 2

func Exit() -> void:
	pass

func Update(delta) -> void:
	if not animation_player.is_playing():
		StateTransitioned.emit(self, "Idle")

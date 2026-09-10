extends State
class_name FrogAttack

@onready var attack: AudioStreamPlayer = $"../../Attack"
@export var parent : Frog
@export var animation_player: AnimationPlayer

func Enter() -> void:
	animation_player.play("Attack")
	parent.Attack()
	if parent.hitboxes_array.size() > 0:
		parent.hitboxes_array[0].damage = 7
	attack.play()
func Exit() -> void:
	pass

func Update(delta) -> void:
	if not animation_player.is_playing():
		StateTransitioned.emit(self, "Idle")

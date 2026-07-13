extends State
class_name MushDash

@export var parent : Mushroom
@export var anim_player : AnimationPlayer

func Enter() -> void:
	parent.friction = 0.05
	anim_player.play("Dash")
	parent.hitboxes_array[0].damage = 5
	parent.increment_damage(parent.main_game_node.enemy_damage_addition)

func Exit() -> void:
	parent.friction = 0.15

func Update(delta) -> void:
	if not anim_player.is_playing():
		StateTransitioned.emit(self, "Idle")

func Physics_Update(delta) -> void:
	pass

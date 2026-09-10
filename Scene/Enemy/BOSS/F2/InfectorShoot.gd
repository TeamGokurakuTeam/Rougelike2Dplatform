extends State
class_name InfectorShoot

@export var parent : Infector
@export var anim_player : AnimationPlayer
@export var idle_timer : Timer

func Enter() -> void:
	parent.flip_character()
	if parent.is_rage:
		for i in 3:
			anim_player.play("Shoot")
			await anim_player.animation_finished
			await get_tree().create_timer(randf_range(0.1, 1.2)).timeout
	else:
		anim_player.play("Shoot")
		await anim_player.animation_finished
	parent.player_dir()
	StateTransitioned.emit(self, "Idle")

func Exit() -> void:
	idle_timer.wait_time = 18.0
	parent.flip_character()

func Update(delta) -> void:
	if parent.hp_component.hp <= parent.hp_component.max_hp / 3 and not parent.is_rage:
		parent.is_rage = true
		StateTransitioned.emit(self, "Rage")

func Physics_Update(delta) -> void:
	pass

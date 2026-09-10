extends State
class_name InfectorSlam

@export var parent : Infector
@export var anim_player : AnimationPlayer

func Enter() -> void:
	parent.flip_character()
	if parent.is_rage:
		for i in 3:
			if i == 2:
				#アニメーション作ったほうが良さそう
				await get_tree().create_timer(2.0).timeout
			anim_player.play("Slam")
			await get_tree().create_timer(0.5).timeout
			if i != 2:
				parent.spawn_slam_custom_bullet(randi_range(20, 40))
			else:
				parent.spawn_slam_custom_bullet(50)
			await anim_player.animation_finished
	else:
		anim_player.play("Slam")
		await get_tree().create_timer(0.5).timeout
		parent.spawn_slam_custom_bullet(randi_range(10, 20))
		await anim_player.animation_finished
	StateTransitioned.emit(self, "Idle")

func Exit() -> void:
	parent.flip_character()

func Update(delta) -> void:
	if parent.hp_component.hp <= parent.hp_component.max_hp / 2 and not parent.is_rage:
		parent.is_rage = true
		StateTransitioned.emit(self, "Rage")

func Physics_Update(delta) -> void:
	pass

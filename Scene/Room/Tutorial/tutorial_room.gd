extends Room
class_name TutorialRoom

@onready var animation_player: AnimationPlayer = $Animation/AnimationPlayer
@onready var camera_2d: Camera2D = $Animation/Camera2D

func _on_player_detecotor_body_entered(body: Node2D) -> void:
	if body is Player:
		GameEvents.cutscene_started.emit()
		main_game_node.player_ui.ui_fade_in()
		await Common.fade_out_to_black(get_tree())
		main_game_node.change_camera(camera_2d)
		await Common.fade_in_from_black()
		animation_player.play("CutScene")
		await animation_player.animation_finished
		GameEvents.next_floor_entered.emit()

extends Room
class_name TutorialRoom

@onready var animation_player: AnimationPlayer = $Animation/AnimationPlayer
@onready var camera_2d: Camera2D = $Animation/Camera2D

func _on_player_detecotor_body_entered(body: Node2D) -> void:
	if body is Player:
		GameEvents.cutscene_started.emit()
		main_game_node.player_ui.ui_fade_in()
		await get_tree().create_timer(1.0).timeout
		main_game_node.change_camera(camera_2d)
		main_game_node.player_ui.ui_fade_out()
		main_game_node.player_ui.visible = false
		await get_tree().create_timer(1.0).timeout
		animation_player.play("CutScene")
		await animation_player.animation_finished
		main_game_node.player_ui.ui_fade_in()
		await get_tree().create_timer(1.0).timeout
		GameEvents.next_floor_entered.emit()

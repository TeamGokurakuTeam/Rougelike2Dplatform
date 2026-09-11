extends Door
class_name SecretDoorFloor1

func _on_player_detector_body_entered(body: Node2D) -> void:
	if GlobalGameState.is_current_floor_boss_killed:
		if randi_range(0, 100) < 5:
			await Common.fade_out_to_black(get_tree())
			print("SECRET")
			await Common.fade_in_from_black()
	else:
		super(body)

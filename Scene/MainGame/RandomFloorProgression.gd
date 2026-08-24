extends FloorProgression
class_name RandomFloorProgression

func start_first_floor() -> void:
	room_generator.room_generate()
	main_game_node.current_room = room_generator.lobby_room
	_move_player_to_lobby()

func _on_next_floor_entered() -> void:
	await Common.fade_out_to_black(main_game_node.get_tree())
	_move_player_to_origin()
	await main_game_node.get_tree().create_timer(0.5).timeout
	room_generator.clear_rooms()
	room_generator.room_generate()
	_move_player_to_lobby()
	main_game_node.current_room = room_generator.lobby_room
	await Common.fade_in_from_black()

func _move_player_to_origin() -> void:
	if player == null or room_generator.lobby_room == null:
		return
	player.global_position = Vector2.ZERO